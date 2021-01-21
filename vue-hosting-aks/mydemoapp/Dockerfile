FROM node:lts-alpine as build-stage
WORKDIR /app
COPY package*.json ./
RUN yarn
COPY . .
RUN yarn run build

FROM nginx:stable-alpine as production-stage
LABEL maintainer="mukherjee.aniket@gmail.com" \
  version="1.0.0"
RUN mkdir /app
COPY --from=build-stage /app/dist /app
COPY nginx/nginx.conf /etc/nginx/nginx.conf