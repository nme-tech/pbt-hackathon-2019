const axios = require('axios');

const BASE_URL = 'https://api.twilio.com';
const mediaList = []; // array to collect media uri info

axios
  .get(
    `${BASE_URL}/2010-04-01/Accounts/${process.env.TWILIO_ACCOUNT_SID}/Messages.json`,
    {
      auth: {
        username: process.env.TWILIO_ACCOUNT_SID,
        password: process.env.TWILIO_AUTH_TOKEN
      }
    }
  )
  .then(response =>
    response.data.messages.map(message => {
      if (message.direction === 'inbound') {
        console.log('----------');
        console.log('From: ', message.from);

        if (message.body) {
          console.log(message.body);
        } else {
          console.log('This is a message with an image');
          mediaList.push(message);
        }
      }
    })
  )
  .catch(error => console.error(error));

// mediaList.map(entry => console.log(entry.media));
