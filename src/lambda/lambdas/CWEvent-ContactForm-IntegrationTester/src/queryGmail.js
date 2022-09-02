const {google} = require('googleapis');

const getDateString = (date) => {
  return '' + date.getFullYear() + '/' + (date.getMonth() + 1) + '/' + (date.getDate());
};

const readMail = async (gmailAuth, query, sinceDay, maxMessages) => {
  const gmail = google.gmail({version: 'v1', auth: gmailAuth});

  return await gmail.users.messages.list({
    userId: 'me',
    q: query + ' after:' + getDateString(sinceDay),
    maxResults: maxMessages,
  });
};


module.exports = {
  doesSingleMessageExist: async (gmailOAuthClient, query, sinceDay) => {
    const result = await readMail(gmailOAuthClient, query, sinceDay, 2);

    return result?.data?.messages && result.data.messages.length === 1;
  },
};