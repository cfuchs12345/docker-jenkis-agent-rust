#!/bin/bash

. env.sh

docker run -d -p $JENKINS_AGENT_SSH_PORT:22 --name $CONTAINER_NAME $IMAGE_NAME:$RUST_VERSION