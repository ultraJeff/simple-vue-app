# build stage
FROM node:lts-alpine as build-stage
USER root
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY ./ .
RUN npm run build \
 && chown -R 1001:1001 . \
 && chmod -R 777 .

USER 1001

# production stage
FROM nginx:stable-alpine as production-stage
# FROM quay.io/polyglotsystems/ubi8-nginx:latest as production-stage
# RUN mkdir /app
COPY --from=build-stage /app/dist /usr/share/nginx/html