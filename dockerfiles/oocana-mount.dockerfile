# syntax=docker/dockerfile:1
# https://github.com/docker/docs/issues/20935
FROM ghcr.io/oomol/server-base:v0.6.0

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
# GitHub Actions multi-arch builds can hit ETXTBSY when esbuild's postinstall
# immediately execs the freshly unpacked binary under buildx/overlayfs.
# npm still installs the platform-specific esbuild optional dependency here, so
# skipping lifecycle scripts only drops the postinstall self-check/shim rewrite.
RUN npm ci --omit=dev --ignore-scripts
RUN pip install -r /app/requirements.txt
