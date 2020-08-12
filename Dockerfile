FROM node:10-alpine as builder

# install and cache app dependencies
COPY package*.json ./
RUN npm install && mkdir /pixelistic_fe && mv ./node_modules ./pixelistic_fe

WORKDIR /pixelistic_fe

COPY . .

ARG REACT_APP_API_WEB
ENV REACT_APP_API_WEB $REACT_APP_API_WEB

ARG REACT_APP_AWS_S3
ENV REACT_APP_AWS_S3 $REACT_APP_AWS_S3


RUN npm run build


# ------------------------------------------------------
# Production Build
# ------------------------------------------------------
FROM nginx:alpine
COPY --from=builder /pixelistic_fe/build /usr/share/nginx/html
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx/nginx.conf /etc/nginx/conf.d
EXPOSE 80

ENTRYPOINT ["nginx", "-g", "daemon off;"]

