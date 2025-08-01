# syntax=docker/dockerfile:1
# https://github.com/docker/docs/issues/20935
FROM ghcr.io/oomol/server-base:v0.4.1 AS builder

WORKDIR /app