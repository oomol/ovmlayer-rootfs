#!/bin/bash

set -e
ovmlayer setup dev --base-rootfs=/root/rootfs.tar --layer-disk=/root/tmp_overlay_desk
exec "$@"