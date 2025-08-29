# syntax=docker/dockerfile:1
# https://github.com/docker/docs/issues/20935
FROM ghcr.io/oomol/server-base:v0.5.0

ARG TARGETPLATFORM
ARG BUILDPLATFORM

# npm config get cache
ENV NPM_CACHE=$HOME/.npm
WORKDIR /app
RUN --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    rm -f /etc/apt/apt.conf.d/docker-clean \
    && apt update \
    && apt install -y --no-install-recommends mosquitto
RUN echo "export PATH=/app:/app/node_modules/.bin:$PATH" >> ~/.bashrc && echo "export PATH=/app:/app/node_modules/.bin:$PATH" >> ~/.zshrc
COPY ./package.json /app/package.json
COPY ./package-lock.json /app/package-lock.json
COPY ./requirements.txt /app/requirements.txt
RUN npm install --omit=dev
# use uv install
RUN pip install -r /app/requirements.txt
# need download oocana
RUN mkdir -p /opt/ovmlayer
COPY ./entrypoint.sh /root/entrypoint.sh
COPY ./amd64 ./amd64
COPY ./arm64 ./arm64
COPY ./scripts/bin.sh /root/bin.sh
RUN TARGETPLATFORM=$TARGETPLATFORM BUILDPLATFORM=$BUILDPLATFORM /root/bin.sh
RUN rm -rf ./amd64 ./arm64
ENTRYPOINT [ "bash", "-x", "/root/entrypoint.sh" ]