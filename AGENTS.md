# AGENTS.md

## Local Agent Notes

- For new Python projects, default to `python3 -m venv .venv`.

## Composite Actions

### `.github/actions/arch-detect`
- Purpose: normalize runner architecture to `amd64` or `arm64`
- Output: `arch`

### `.github/actions/fetch`
- Purpose: download `oocana`, `ovmlayer`, and `rootfs.tar` into a target directory
- Required inputs: `architecture`, `destination`, `ovmlayer_app_id`, `ovmlayer_app_private_key`
- Optional inputs: `token`, `oocana`, `ovmlayer`, `rootfs`, `platform`
- Outputs: `oocana_version`, `ovmlayer_version`, `rootfs_version`
- Notes: `platform=cloud` pulls `ovmlayer` from `oomol/ovmlayer-next`; otherwise it uses `oomol/ovmlayer`

### `.github/actions/build-context`
- Purpose: wrap `fetch` for Docker multi-arch build context preparation under `${{ github.workspace }}`
- Typical output directories: `${{ github.workspace }}/amd64`, `${{ github.workspace }}/arm64`
- Outputs: `oocana_version`, `ovmlayer_version`, `rootfs_version`

### `.github/actions/oocana-runtime`
- Purpose: install `oocana` and `ovmlayer` onto the GitHub Actions runner, then set up a rootfs overlay
- Required inputs: `architecture`, `ovmlayer_app_id`, `ovmlayer_app_private_key`
- Optional inputs: `token`, `oocana`, `ovmlayer`, `rootfs`, `platform`
- Outputs: `oocana_version`, `ovmlayer_version`, `rootfs_version`
- Notes: `platform=studio` runs `ovmlayer setup dev`; `platform=cloud` runs `ovmlayer setup` with a writable overlay

## Required GitHub Configuration

- Repository variable: `OOMOL_DOWNLOADER_APP_ID`
- Repository secret: `OOMOL_DOWNLOADER_APP_PRIVATE_KEY`
