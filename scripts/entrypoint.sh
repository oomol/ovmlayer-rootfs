#!/bin/bash

set -e
if [ ! -d "/opt/ovmlayer" ]; then
  echo "[Init] /opt/ovmlayer directory not found, initializing with dev mode."
  ovmlayer setup dev --base-rootfs=/root/rootfs.tar --layer-disk=/root/tmp_overlay_disk
elif [ -d "/opt/ovmlayer/layer_dir/base_rootfs/" ]; then
  echo "[Init] Detected existing Layer data, skipping initialization."
else
  echo "[Init] Initializing Layer with production configuration."
  ovmlayer setup production --base-rootfs=/root/rootfs.tar
fi
exec "$@"