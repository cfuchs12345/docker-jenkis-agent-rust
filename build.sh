#!/bin/bash
. env.sh

mkdir -p .ssh
cp -r ~/.ssh/authorized_keys .ssh

docker build -t \
$IMAGE_NAME:$RUST_VERSION \
--build-arg DEBIAN_VERSION=$DEBIAN_VERSION \
--build-arg RUST_VERSION=$RUST_VERSION \
--build-arg RUSTUP_VERSION=$RUSTUP_VERSION \
--build-arg JENKINS_USER=$JENKINS_USER \
--build-arg JENKINS_PASSWORD=$JENKINS_PASSWORD \
.