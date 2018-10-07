#!/bin/bash

set -x
set -e

. scripts/env.sh

###########################
#
# This script is designed to
# be run inside the docker
#
##########################

: ${CLUSTER_NAME:?"Need to set CLUSTER_NAME env var"}
: ${ENVIRONMENT_NAME:?"Need to set ENVIRONMENT_NAME env var"}
: ${VPC_CIDR:?"Need to set VPC_CIDR env var"}
: ${VPC_NAME:?"Need to set VPC_NAME env var"}

: ${AWS_ACCESS_KEY_ID:?"Need to set AWS_ACCESS_KEY_ID env var"}
: ${AWS_SECRET_ACCESS_KEY:?"Need to set AWS_SECRET_ACCESS_KEY env var"}
: ${AWS_DEFAULT_REGION:?"Need to set AWS_DEFAULT_REGION env var"}

run_docker(){
docker run --rm \
--mount src="$(pwd)/terraform",target=/terraform,type=bind \
--mount src="$(pwd)/k8s-specs",target=/k8s-specs,type=bind \
--env AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
--env AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
--env AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION} \
--env TF_VAR_cluster_name=${CLUSTER_NAME} \
--env TF_VAR_environment_name=${ENVIRONMENT_NAME} \
--env TF_VAR_vpc_cidr=${VPC_CIDR} \
--env TF_VAR_vpc_name=${VPC_NAME} \
--env TF_VAR_aws_region=${AWS_DEFAULT_REGION} \
--workdir $1 \
-it aws-k8s-vpn-starter-kit:v1 $2
}

terraform-plan(){
run_docker /terraform "terraform plan -out plan"
}

if [ -z ${1+x} ]; then 
  echo "ERROR: You must pass a command"; 
  echo "Example Usage:"
  echo "kit.sh terraform_plan"
  exit 1;
fi
$1
