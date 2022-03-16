FROM node:16 as build

WORKDIR /app

# COPY package.json ./
# COPY ./src ./src/
# .dockerignore zawiera pomijanie pliki i katalogi
COPY . .

RUN npm install

RUN npm run build

FROM nginx:latest

COPY --from=build /app/dist/helloapp /usr/share/nginx/html
EXPOSE 80
