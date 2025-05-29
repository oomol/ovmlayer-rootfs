FROM ubuntu:latest

RUN sed -i 's|http://archive.ubuntu.com/ubuntu/|http://azure.archive.ubuntu.com/ubuntu/|g' /etc/apt/sources.list.d/ubuntu.sources
RUN apt update && apt install zsh -y