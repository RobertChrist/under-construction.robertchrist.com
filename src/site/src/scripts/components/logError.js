export default async function(config, error) {
  try {

    console.error(error);

    const data = {
      name: error?.name,
      message: error?.message,
      stack: error?.stack,
      callingApp: config.appName,
      additionalDetails: 'required?',
    };

    const response = await fetch(config.logErrorUri, {
      method: 'post',
      mode: 'cors',
      body: JSON.stringify(data),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': config.apiKey,
      },
    });

    return response.ok;

  } catch (err) {
    console.error(err);
    return false;
  }
}