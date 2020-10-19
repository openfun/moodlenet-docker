ARG NGINX_IMAGE_NAME=fundocker/openshift-nginx
ARG NGINX_IMAGE_TAG=1.13


# === DOWNLOAD ===
FROM busybox as downloader

WORKDIR /download

RUN wget https://gitlab.com/moodlenet/frontend/-/archive/master/frontend-master.tar.gz && \
    tar xzf frontend-master.tar.gz && \
    rm frontend-master.tar.gz && \
    mv frontend-master frontend

# === BUILD ===
FROM node:14-slim as builder

WORKDIR /app

COPY --from=downloader /download/frontend .

RUN yarn && \
    yarn build --prod

# === PRODUCTION ===
FROM ${NGINX_IMAGE_NAME}:${NGINX_IMAGE_TAG} as nginx

WORKDIR /app

COPY --from=builder /app/build .


