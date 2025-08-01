# syntax=docker/dockerfile:1
# https://github.com/docker/docs/issues/20935
FROM ghcr.io/oomol/server-base:v0.4.1

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
COPY ./oocana /app/
COPY ./ovmlayer /app/
COPY ./rootfs.tar /root/rootfs.tar
ENTRYPOINT [ "bash", "-x", "/root/entrypoint.sh" ]