const client = require("../client");

module.exports = id =>
  new Promise((res, rej) => {
    client.delete({ id }, error => {
      if (!error) {
        return res();
      }

      rej(error);
    });
  });
