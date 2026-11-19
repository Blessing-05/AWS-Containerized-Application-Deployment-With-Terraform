FROM node:22-alpine

WORKDIR /app

COPY package.json .

RUN npm install --omit=dev

COPY . .

RUN adduser -D nodeuser && chown -R nodeuser:nodeuser /app

USER nodeuser

EXPOSE 3000

CMD [ "node", "app.js" ]