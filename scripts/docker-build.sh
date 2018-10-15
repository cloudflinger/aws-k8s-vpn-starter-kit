#!/bin/bash

# set -x
set -e

. ./scripts/_bootstrap_env.sh
bootstrap-env

docker-build-kit(){
DEFAULT_KUBECTL_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
KIT_KUBECTL_VERSION=${KIT_KUBECTL_VERSION:-$DEFAULT_KUBECTL_VERSION}
BUILD_ARGS="--build-arg TF_VERSION=${KIT_TF_VERSION} --build-arg KUBECTL_VERSION=${KIT_KUBECTL_VERSION}"
docker build ${BUILD_ARGS} -t ${KIT_IMAGE_NAME} .
}

docker-build-kit