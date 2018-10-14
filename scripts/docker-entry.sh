#!/bin/bash

# set -x
set -e

run_docker(){
# NOTE: the uid bit makes docker write files as the user running it so that root doesn't own the file on the host machine
docker run --rm \
--mount src="$(pwd)",target=${WORK_DIR},type=bind \
--env AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
--env AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
--env AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION} \
--env TF_VAR_cluster_name=${KIT_CLUSTER_NAME} \
--env TF_VAR_environment_name=${KIT_ENVIRONMENT_NAME} \
--env TF_VAR_vpc_cidr=${KIT_VPC_CIDR} \
--env TF_VAR_vpc_name=${KIT_VPC_NAME} \
--env TF_VAR_aws_region=${AWS_DEFAULT_REGION} \
--workdir ${WORK_DIR} \
-it \
-u=$UID:$(id -g $USER) \
aws-k8s-vpn-starter-kit:v1 \
scripts/kit.sh ${@}
}

docker-build-kit(){
DEFAULT_KUBECTL_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
KIT_KUBECTL_VERSION=${KIT_KUBECTL_VERSION:-$DEFAULT_KUBECTL_VERSION}
BUILD_ARGS="--build-arg TF_VERSION=${KIT_TF_VERSION} --build-arg KUBECTL_VERSION=${KIT_KUBECTL_VERSION}"
docker build ${BUILD_ARGS} -t ${KIT_IMAGE_NAME} .
}

init(){
if [ -z ${1+x} ]; then
  echo "ERROR: You must pass a command";
  echo "Example Usage:"
  echo "docker-entry.sh terraform-plan"
  exit 1;
fi

ENV_SCRIPT=config.sh
. $ENV_SCRIPT

if [ ! -z "${AWS_PROFILE}" ]; then
	. ./scripts/aws_exporter.sh ${AWS_PROFILE}
fi

: ${AWS_ACCESS_KEY_ID:?"Need to set AWS_ACCESS_KEY_ID env var"}
: ${AWS_SECRET_ACCESS_KEY:?"Need to set AWS_SECRET_ACCESS_KEY env var"}
: ${AWS_DEFAULT_REGION:?"Need to set AWS_DEFAULT_REGION env var"}

KIT_IMAGE_NAME="aws-k8s-vpn-starter-kit:v1"
WORK_DIR="/workdir"
}

init $@

# pass in all subsequent arguments to the function named by the first argument
run_docker ${@}
