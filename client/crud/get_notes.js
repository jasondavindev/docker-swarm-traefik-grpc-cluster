const client = require("../client");

module.exports = () =>
  new Promise((res, rej) => {
    client.list({}, (error, notes) => {
      if (!error) {
        return res(notes);
      }

      rej(error);
    });
  });
