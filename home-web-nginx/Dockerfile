FROM nginx:alpine
# COPY default.conf /etc/nginx/conf.d/default.conf

RUN apk add --no-cache tzdata

EXPOSE 80
# Nginx起動
CMD ["nginx", "-g", "daemon off;"]
