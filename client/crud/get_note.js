const client = require("../client");

module.exports = id =>
  new Promise((res, rej) => {
    client.get({ id }, (error, note) => {
      if (!error) {
        return res(note);
      }

      rej(error);
    });
  });
