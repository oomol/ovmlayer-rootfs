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
COPY ./scripts/entrypoint.sh /root/entrypoint.sh
# Mount architecture-specific files, copy only what's needed based on TARGETPLATFORM
RUN --mount=type=bind,source=./amd64,target=/tmp/amd64 \
    --mount=type=bind,source=./arm64,target=/tmp/arm64 \
    if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
      cp -r /tmp/amd64/oocana /usr/bin/ && \
      cp -r /tmp/amd64/ovmlayer/* /usr/bin/ && \
      cp /tmp/amd64/rootfs.tar /root/rootfs.tar; \
    elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
      cp -r /tmp/arm64/oocana /usr/bin/ && \
      cp -r /tmp/arm64/ovmlayer/* /usr/bin/ && \
      cp /tmp/arm64/rootfs.tar /root/rootfs.tar; \
    else \
      echo "Unsupported platform: $TARGETPLATFORM" && exit 23; \
    fi
ENTRYPOINT [ "bash", "-x", "/root/entrypoint.sh" ]