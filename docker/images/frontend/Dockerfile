ARG NGINX_IMAGE_NAME=fundocker/openshift-nginx
ARG NGINX_IMAGE_TAG=1.13


# === DOWNLOAD ===
FROM busybox as downloader

WORKDIR /download

# Moodlenet frontend version that you want to build (git commit, tag or branch name)
# related to the official repository : https://gitlab.com/moodlenet/frontend/
ARG MOODLENET_VERSION=master

RUN wget https://gitlab.com/moodlenet/frontend/-/archive/${MOODLENET_VERSION}/frontend-${MOODLENET_VERSION}.tar.gz && \
    tar xzf frontend-${MOODLENET_VERSION}.tar.gz && \
    rm frontend-${MOODLENET_VERSION}.tar.gz && \
    mv frontend-${MOODLENET_VERSION} frontend

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


