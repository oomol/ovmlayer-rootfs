# syntax=docker/dockerfile:1
# https://github.com/docker/docs/issues/20935
FROM ghcr.io/oomol/server-base:v0.3.3 AS builder

# npm config get cache
ENV NPM_CACHE=$HOME/.npm
WORKDIR /app
RUN echo "export PATH=/app/node_modules/.bin:$PATH" >> ~/.bashrc && echo "export PATH=/app/node_modules/.bin:$PATH" >> ~/.zshrc
COPY ./package.json /app/package.json
COPY ./requirements.txt /app/requirements.txt
RUN npm pkg delete dependencies.@oomol/oocana && npm install
# use uv install
RUN pip install -r /app/requirements.txt