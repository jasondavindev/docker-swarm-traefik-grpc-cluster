FROM node:12.14.0 as server

RUN mkdir -p /home/node/app && \
  chown -R node:node /home/node

WORKDIR /home/node/app

USER node

COPY package.json yarn.lock ./

RUN yarn install

COPY . .

EXPOSE 50051

CMD [ "node", "index.js" ]

FROM server as client

EXPOSE 3000

CMD [ "node", "resources/index.js" ]
