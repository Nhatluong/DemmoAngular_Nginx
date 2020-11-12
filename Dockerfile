FROM node:15.1-alpine as build
ARG BUILDENV="staging"
RUN mkdir -p /opt/app
WORKDIR /opt/app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM nginx:1.19-alpine
COPY docker-env/web/nginx.conf /etc/nginx/nginx.conf
COPY --from=build /opt/app/dist/angular-docker /var/www/html
CMD ["nginx", "-g", "daemon off;"]