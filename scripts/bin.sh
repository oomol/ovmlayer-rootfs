#!/usr/bin/env bash
set -x
echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM" > /tmp/1.log
if [ "$TARGETPLATFORM" == "linux/amd64" ]; then
  echo "Downloading amd64 oocana and ovmlayer" >> /tmp/1.log
  cp -r ./amd64/oocana /app/
  cp -r ./amd64/ovmlayer /app/
  cp ./amd64/rootfs.tar /root/rootfs.tar
elif [ "$TARGETPLATFORM" == "linux/arm64" ]; then
  echo "Downloading arm64 oocana and ovmlayer" >> /tmp/1.log
  cp -r ./arm64/oocana /app/
  cp -r ./arm64/ovmlayer /app/
  cp ./arm64/rootfs.tar /root/rootfs.tar
else
  echo "Unsupported platform: $TARGETPLATFORM" >> /tmp/1.log
  exit 23
fi