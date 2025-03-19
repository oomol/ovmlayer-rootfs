# ovmlayer-rootfs

this repo give three artifacts:

1. base-rootfs
2. studio-image image
3. studio-rootfs


## base-rootfs

base rootfs is a minimal rootfs that is used to run oocana-rust layer feature which only contains basic linux rootfs and zsh shell. It is used to run [oocana-rust](https://gihub.com/oomol/oocana-rust) layer mod test case.

## studio-rootfs

this is a rootfs that has add additional python-executor and nodejs-executor to run python and nodejs block. this rootfs is used to run python and nodejs block for oocana-rust layer feature.

## studio-image

this is a image that contains oocana, ovmlayer, python-executor and nodejs-executor.  With this image, you can run oocana directly with layer feature. This should be most used image for oocana-rust layer feature.