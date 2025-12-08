# ovmlayer-rootfs

This repository builds multi-architecture (amd64/arm64) rootfs tarballs and container images for Oocana runtime environments.

## Artifacts

### 1. Base Rootfs (`rootfs-base.yml`)
Minimal Ubuntu-based rootfs with Zsh shell for ovmlayer layer testing.
- **Purpose**: Basic Linux container foundation for [oocana-rust](https://github.com/oomol/oocana-rust) layer feature tests
- **Contents**: Minimal Linux userspace + Zsh
- **Trigger**: Tags matching `base-rootfs*`

### 2. Server Rootfs (`rootfs-server.yml`)
Server base rootfs built from upstream `ghcr.io/oomol/server-base` foundation image.
- **Purpose**: Foundation layer for studio runtime builds
- **Trigger**: Tags matching `server-base*`

### 3. Executor Layer (`layer-executor.yml`)
Python and Node.js executor dependencies layer for workflow execution.
- **Purpose**: Run Python and Node.js blocks in oocana-rust layer feature
- **Contents**: Python executor + Node.js executor (without oocana CLI)
- **Trigger**: Tags matching `executor-layer*`

### 4. Runtime Image (`image-runtime.yml`)
Complete Oocana runtime container image with CLI and ovmlayer.
- **Purpose**: Run oocana directly without layer feature
- **Contents**: oocana CLI + ovmlayer (executor layers are separate tar artifacts)
- **Registry**: `ghcr.io/oomol/oocana-runtime`

## Workflows

| Workflow | Purpose | Trigger |
|----------|---------|---------|
| `rootfs-base.yml` | Build minimal base rootfs | `base-rootfs*` tags |
| `rootfs-server.yml` | Build server foundation rootfs | `server-base*` tags |
| `layer-executor.yml` | Build Python/Node.js executor layer | `executor-layer*` tags |
| `image-runtime.yml` | Build runtime image with CLI and ovmlayer | Push to main or workflow_dispatch |
| `layer-package.yml` | Package custom layers (reusable workflow) | Called by other repos |
| `test-actions.yml` | Test all GitHub Actions | PR or workflow_dispatch |

## Usage

### Run Oocana with Runtime Image
```shell
docker run -d ghcr.io/oomol/oocana-runtime:latest
mosquitto -d -p 47688
oocana run <flow-yaml>
```

### Build Custom Layer
Use `layer-package.yml` as a reusable workflow in your repository to create custom package layers.