#!/bin/bash
DEBIAN_VERSION=bullseye
RUST_VERSION=1.67.1
RUSTUP_VERSION=1.25.2
RUST_ARCH=x86_64-unknown-linux-gnu
CONTAINER_NAME=docker-jenkins-agent-rust
IMAGE_NAME=docker-jenkins-agent-rust
JENKINS_AGENT_SSH_PORT=2222 # port is only used in run script - ssh daemon listens at port 22 - docker maps the port to given SSH_PORT
JENKINS_USER=jenkins
JENKINS_PASSWORD=jenkins

export DEBIAN_VERSION
export RUST_VERSION
export RUSTUP_VERSION
export CONTAINER_NAME
export JENKINS_AGENT_SSH_PORT
export JENKINS_USER
export JENKINS_PASSWORD
export IMAGE_NAME