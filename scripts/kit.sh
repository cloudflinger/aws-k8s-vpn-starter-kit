#!/bin/bash

set -x
set -e

. scripts/env.sh

if [ ! -z "${AWS_PROFILE}" ]; then
	. ./scripts/aws_exporter.sh ${AWS_PROFILE}
fi

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
aws-k8s-vpn-starter-kit:v1 \
${@:2}
}

terraform-init(){
run_docker /terraform "terraform init"
}

terraform-plan(){
run_docker /terraform "terraform plan -out plan"
}

terraform-apply(){
run_docker /terraform "terraform apply plan"
run_docker /terraform "rm plan"
}

terraform-destroy(){
run_docker /terraform "terraform destroy"
}

kubectl-apply(){
  run_docker /k8s-specs "kubectl --kubeconfig /terraform/kubeconfig_${CLUSTER_NAME} create -f 00_storage_class.yaml" && true
  # run_docker /k8s-specs "for SPEC in $(ls -1 01_olm*);do kubectl -f $SPEC;done"
  run_docker /k8s-specs "kubectl --kubeconfig /terraform/kubeconfig_${CLUSTER_NAME} create -f 01_olm-0.7.0/"
  run_docker /k8s-specs "kubectl --kubeconfig /terraform/kubeconfig_${CLUSTER_NAME} create -f 02_vpn_operator.yaml"
  run_docker /k8s-specs "kubectl --kubeconfig /terraform/kubeconfig_${CLUSTER_NAME} create -f 03_vpn_cr.yaml"
}

if [ -z ${1+x} ]; then
  echo "ERROR: You must pass a command";
  echo "Example Usage:"
  echo "kit.sh terraform-plan"
  exit 1;
fi
$1
