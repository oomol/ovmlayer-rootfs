# ovmlayer-rootfs

```shell
docker build --secret id=npmrc,src=$HOME/.npmrc -t ovmlayer-rootfs -f .Dockerfile .

docker run -d --name rootfs ovmlayer-rootfs true
docker export rootfs > rootfs.tar
docker rm rootfs
```