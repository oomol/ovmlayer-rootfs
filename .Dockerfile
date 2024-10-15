# syntax=docker/dockerfile:1
FROM ghcr.io/oomol/server-base:v0.2.1 AS builder

# npm config get cache
ENV NPM_CACHE=$HOME/.npm
WORKDIR /app
RUN --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    rm -f /etc/apt/apt.conf.d/docker-clean \
    && apt update \
    && apt install -y --no-install-recommends locales-all tar xz-utils uuid-runtime mosquitto
RUN echo "export PATH=/app/node_modules/.bin:$PATH" >> ~/.bashrc && echo "export PATH=/app/node_modules/.bin:$PATH" >> ~/.zshrc
COPY ./package.json /app/package.json
RUN --mount=type=secret,id=npmrc,target=/root/.npmrc --mount=type=secret,id=token,env=NODE_AUTH_TOKEN --mount=type=cache,target=${NPM_CACHE} npm install
RUN pip install /app/node_modules/@oomol/python-sdk/dist/*.whl
RUN ln -sf /app/node_modules/@oomol/ovmlayer/ovmlayer /usr/local/bin/ovmlayer