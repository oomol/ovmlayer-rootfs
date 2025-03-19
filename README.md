# ovmlayer-rootfs

this repo give three artifacts:

1. base-rootfs
1. layer-rootfs
1. studio-image

## base-rootfs

base rootfs is a minimal rootfs that is used to run oocana-rust layer feature which only contains basic linux rootfs and zsh shell. It is used to run [oocana-rust](https://gihub.com/oomol/oocana-rust) layer mod test case.

## layer-rootfs

this is a rootfs that has add additional python-executor and nodejs-executor to run python and nodejs block, but without oocana cli.
this rootfs is used to run python and nodejs block for oocana-rust layer feature.

## studio-image

this is a image that contains oocana, ovmlayer, python-executor and nodejs-executor.  With this image, you can run oocana directly(without layer feature). This image should be used to run oocana directly.

```shell
mosquitto -d -p 47688
oocana run <flow-yaml>
```