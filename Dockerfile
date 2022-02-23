FROM node:16 as build

WORKDIR /usr/local/app

# COPY package.json ./
# COPY ./src ./src/
# .dockerignore zawiera pomijanie pliki i katalogi
COPY . .

RUN npm install

RUN npm run build

FROM nginx:latest

COPY --from=build /usr/local/app/dist/helloapp /usr/share/nginx/html
EXPOSE 80
