ARG ELIXIR_IMAGE_NAME=elixir
ARG ELIXIR_IMAGE_TAG=1.10.2-slim


# === DOWNLOAD ===
FROM busybox as downloader

WORKDIR /download

# Moodlenet backend version that you want to build (git commit, tag or branch name)
# related to the official repository : https://gitlab.com/moodlenet/backend/
ARG MOODLENET_VERSION=master

RUN wget "https://gitlab.com/moodlenet/backend/-/archive/${MOODLENET_VERSION}/backend-${MOODLENET_VERSION}.tar.gz" && \
    tar xzf "backend-${MOODLENET_VERSION}.tar.gz" && \
    rm "backend-${MOODLENET_VERSION}.tar.gz" && \
    mv "backend-${MOODLENET_VERSION}" backend

# === BUILD ===
FROM ${ELIXIR_IMAGE_NAME}:${ELIXIR_IMAGE_TAG} as builder

# The name of your application/release (required)
ARG APP_NAME
ARG APP_VSN
ARG APP_BUILD

WORKDIR /app

ENV HOME=/app/
ENV TERM=xterm
ENV MIX_ENV=prod

# dependencies for comeonin
RUN apt-get update && \
    apt-get install -y build-essential cmake curl git rustc cargo && \
    rm -rf /var/lib/apt/lists/*

# Cache elixir deps
COPY --from=downloader /download/backend/mix.exs .
COPY --from=downloader /download/backend/mix.lock .
RUN mix do local.hex --force, local.rebar --force, deps.get, deps.compile

COPY --from=downloader /download/backend .
RUN mix release

# === PRODUCTION ===
FROM debian:buster as moodlenet

ENV LANG=en_US.UTF-8

RUN apt-get update && \
    apt-get install -y ca-certificates libssl-dev locales tzdata && \
    rm -rf /var/lib/apt/lists/*

RUN echo "$LANG UTF-8" >> /etc/locale.gen && \
    locale-gen && \
    update-locale LANG="$LANG"

# The name of your application/release (required)
ARG APP_NAME=Moodlenet-${MOODLENET_VERSION}
ENV APP_NAME=${APP_NAME}

WORKDIR /app

# install app
COPY --from=builder /app/_build/prod/rel/moodle_net /app
COPY ./docker/files/usr/local/bin/entrypoint /usr/local/bin/entrypoint

# Un-privileged user running the application
ARG DOCKER_USER

# fix app permissions and ownership
RUN chmod -R g=u /app/ && \
    chown -R ${DOCKER_USER} /app/ && \
    chgrp -R 0 /app

# Give the "root" group the same permissions as the "root" user on /etc/passwd
# to allow a user belonging to the root group to add new users; typically the
# docker user (see entrypoint).
RUN chmod g=u /etc/passwd

USER ${DOCKER_USER}

# We wrap commands run in this container by the following entrypoint that
# creates a user on-the-fly with the container user ID (see USER) and root group
# ID.
ENTRYPOINT [ "/usr/local/bin/entrypoint" ]
CMD /app/bin/moodle_net start
