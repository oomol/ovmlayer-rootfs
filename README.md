# ovmlayer-rootfs

This repository builds Oomol runtime assets for `amd64` and `arm64`.

## Release Artifacts

### Base Rootfs

Minimal Ubuntu-based rootfs with `zsh`, used as the lightest ovmlayer test base.

- Architecture: `amd64`, `arm64`
- Output files: `amd64-rootfs.tar`, `arm64-rootfs.tar`
- Tag trigger: `base-rootfs*`
- Workflow: `rootfs-base.yml`

### Server Rootfs

Server foundation rootfs used by runtime-related builds.

- Architecture: `amd64`, `arm64`
- Output files: `amd64-server-base.tar`, `arm64-server-base.tar`
- Tag trigger: `server-base*`
- Workflow: `rootfs-server.yml`

### Studio Executor Layer

Executor layer for studio runtime, built from Python dependencies in `requirements.txt` and Node.js dependencies in `package.json`.

- Architecture: `amd64`, `arm64`
- Output files: `amd64-executor.tar`, `arm64-executor.tar`
- Tag trigger: `executor-layer*`
- Workflow: `layer-executor.yml`

### Cloud Executor Layer

Executor layer for cloud runtime, built from the same dependency sources as the studio executor layer.

- Architecture: `amd64`, `arm64`
- Output files: `amd64-executor.tar`, `arm64-executor.tar`
- Tag trigger: `cloud-executor-layer*`
- Workflow: `layer-cloud-executor.yml`

## Container Images

### Runtime Image

Container image with `oocana` and `ovmlayer` for directly running the runtime environment. Executor layers are released separately and are not baked into this image.

- Image: `ghcr.io/oomol/oocana-runtime`
- Includes:
  - `oocana` binary in `/usr/bin/oocana`
  - `ovmlayer` binaries in `/usr/bin/`
  - bundled rootfs tarball at `/root/rootfs.tar`
  - layer working directory at `/opt/ovmlayer`
  - runtime dependencies from `package.json`, `requirements.txt`, and `mosquitto`
- Startup behavior:
  - runs [`scripts/entrypoint.sh`](/Users/yleaf/oomol/ovmlayer-rootfs/scripts/entrypoint.sh), which initializes ovmlayer from `/root/rootfs.tar` if needed
- Tag trigger: `oocana-runtime*`
- Workflow: `image-oocana-runtime.yml`

### Oocana Mount Image

Container image for running Oocana with mounted rootfs support.

- Image: `ghcr.io/oomol/oocana-mount`
- Includes:
  - runtime dependencies from `package.json`, `requirements.txt`, and `mosquitto`
  - does not currently bake `oocana`, `ovmlayer`, or `rootfs.tar` into the image
- Intended use:
  - provide the dependency environment for scenarios where rootfs and related layer assets are mounted from outside the container
- Tag trigger: `oocana-mount*`
- Workflow: `image-oocana-mount.yml`

## Workflow Mapping

| Workflow | Tag trigger | Build artifacts |
| --- | --- | --- |
| `rootfs-base.yml` | `base-rootfs*` | `amd64-rootfs.tar`, `arm64-rootfs.tar` |
| `rootfs-server.yml` | `server-base*` | `amd64-server-base.tar`, `arm64-server-base.tar` |
| `layer-executor.yml` | `executor-layer*` | `amd64-executor.tar`, `arm64-executor.tar` |
| `layer-cloud-executor.yml` | `cloud-executor-layer*` | `amd64-executor.tar`, `arm64-executor.tar` |
| `image-oocana-runtime.yml` | `oocana-runtime*` | `ghcr.io/oomol/oocana-runtime` |
| `image-oocana-mount.yml` | `oocana-mount*` | `ghcr.io/oomol/oocana-mount` |

## Other Workflows

| Workflow | Trigger | Purpose |
| --- | --- | --- |
| `test-actions.yml` | pull request on action files, `workflow_dispatch` | Verifies reusable actions in this repository. |
| `export-package-layer.yml` | `workflow_call` | Deprecated compatibility workflow that only prints a warning. |
