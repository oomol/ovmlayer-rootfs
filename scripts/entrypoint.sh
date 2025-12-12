#!/bin/bash

set -e

# 检查是否为只读，如果是，则重新挂载为读写
if [ -w "/sys/fs/cgroup" ]; then
    echo "/sys/fs/cgroup is writable"
else
    echo "Remounting /sys/fs/cgroup as RW..."
    mount -o remount,rw /sys/fs/cgroup
fi

# 某些情况下（特别是 cgroup v2），可能还需要挂载 cgroup2
mount -t cgroup2 none /sys/fs/cgroup

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