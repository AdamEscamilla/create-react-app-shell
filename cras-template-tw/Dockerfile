FROM node:alpine

WORKDIR /app

COPY package.json package.json
# Pin dependencies
#COPY package-lock.json package-lock.json
COPY webpack.js .
COPY env .env

RUN npm init -y
RUN npm install --save-dev \
    webpack \
    webpack-cli \
    babel-loader \
    @babel/core \
    @babel/preset-env \
    @babel/preset-react \
    react \
    react-dom \
    react-router-dom \
    css-loader \
    mini-css-extract-plugin \
    file-loader \
    @babel/plugin-proposal-class-properties \
    regenerator-runtime \
    dotenv-webpack \
    eslint-config-prettier \
    webpack-dev-server \
    react-devtools

RUN npm install --only=dev

EXPOSE 3000
ENV PATH /node_modules/.bin:$PATH
#CMD ["yarn","dev"]
CMD ["npm","run","dev"]
