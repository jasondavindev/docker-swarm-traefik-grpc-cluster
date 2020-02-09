const client = require("../client");

module.exports = note =>
  new Promise((res, rej) => {
    client.insert(note, (error, data) => {
      if (!error) {
        return res(data);
      }
      rej(error);
    });
  });
