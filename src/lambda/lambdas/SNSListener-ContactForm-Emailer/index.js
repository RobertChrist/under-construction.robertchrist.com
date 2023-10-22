const config = require('dotenv').config();
const nodemailer = require('nodemailer');
const {google} = require('googleapis');
const OAuth2 = google.auth.OAuth2;
const SNS = new (require('aws-sdk')).SNS();

const ensureConfig = () => {
    if (config.error)
        throw config.error;
};

const validateGRecaptchaToken = async (env, token) => {
    const response = await fetch('https://www.google.com/recaptcha/api/siteverify', {
        method: 'POST',
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: `secret=${env.grecaptchaSecretKey}&response=${token}`
    });

    const data = await response.json();
    console.log('recaptcha responded with: ' + JSON.stringify(data));
      
    return data.success;
};

const sendSMS = async (env, passCaptcha, contactInfo) => {
    const data = JSON.stringify(contactInfo);
    const msg = passCaptcha ? data : 'Message failed captcha: ' + data;
    
    const payload = {
        'PhoneNumber': env.phoneNumber,
        'Message': msg
    };
    
    console.log("Sending sms message: " + JSON.stringify(payload));

    return await (new Promise((resolve, reject) => 
        SNS.publish(payload,(err, data) => err ? reject(err) : resolve(data))
    ));
}

const getEmailMessage = (name, callingApp, emailAddress, message) => {
    return {
        subject: name + ' has sent you a contact request via ' + callingApp,
        text: 'name: ' + name + '\r\n'
            + 'email address: ' + emailAddress + '\r\n'
            + 'message: ' + message,
    };
};

const getAccessToken = async (env) => {
    const oauth2Client = new OAuth2(
        env.clientId,
        env.clientSecret,
        'https://developers.google.com/oauthplayground',
    );

    oauth2Client.setCredentials({
        refresh_token: env.refreshToken,
    });

    // Realistically, for this website, we are expecting that this lambda is going to
    // be run extremely infrequently, likely on the order of once per every few days.
    // As a result, we can save ourselves some trouble by just grabbing a new access token on each run.
    // If we were expecting more traffic, updating this lambda to handle more messages per run,
    // and reusing/sharing access tokens until they expire would be a better practice.
    return await oauth2Client.getAccessToken();
};

const sendMail = async (env, accessToken, msg) => {
    const mailOptions = {
        from: env.fromAddress,
        to: env.toAddress,
        subject: msg.subject,
        generateTextFromHTML: true,
        text: msg.text,
    };

    const smtpTransport = nodemailer.createTransport({
        service: 'gmail',
        auth: {
            type: 'OAuth2',
            user: env.user,
            clientId: env.clientId,
            clientSecret: env.clientSecret,
            refreshToken: env.refreshToken,
            accessToken: accessToken,
        },
        tls: {
            rejectUnauthorized: false,
        },
    });

    try {
        const res = await smtpTransport.sendMail(mailOptions);

        return res.accepted?.length === 1;
    } finally {
        smtpTransport.close();
    }
};

const main = async (context, event) => {
    try {
        console.log('Handler has been called with event ' + JSON.stringify(event));

        ensureConfig();

        // SNS notifications always have exactly 1 record.
        const data = JSON.parse(context.Records[0].Sns.Message);

        console.log('with this data ' + JSON.stringify(data));

        const {token, ...contactInfo} = data;
        const passCaptcha = await validateGRecaptchaToken(process.env, token);
        await sendSMS(process.env, passCaptcha, contactInfo);

        if (!passCaptcha)
            return console.warn('This event failed recaptcha verification');

        const msg = getEmailMessage(data.name, data.callingApp, data.email, data.message);
        const accessToken = await getAccessToken(process.env);
        const result = await sendMail(process.env, accessToken, msg);

        if (!result)
            throw Error('Gmail was Unable to Send the Attempted Email');
    } catch (err) {
        console.error(err);

        throw err;
    }
};

exports.handler = main;