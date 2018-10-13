#!/bin/bash

set -x
set -e

run_docker(){
docker run --rm \
--mount src="$(pwd)/terraform",target=/terraform,type=bind \
--mount src="${K8S_WORK_DIR}",target=/k8s-specs,type=bind \
--env AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
--env AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
--env AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION} \
--env TF_VAR_cluster_name=${KIT_CLUSTER_NAME} \
--env TF_VAR_environment_name=${KIT_ENVIRONMENT_NAME} \
--env TF_VAR_vpc_cidr=${KIT_VPC_CIDR} \
--env TF_VAR_vpc_name=${KIT_VPC_NAME} \
--env TF_VAR_aws_region=${AWS_DEFAULT_REGION} \
--workdir $1 \
-it \
aws-k8s-vpn-starter-kit:v1 \
${@:2}
}

run_terraform(){
run_docker /terraform terraform ${@}
}

terraform-init(){
run_terraform init
}

terraform-plan(){
run_terraform plan -out plan
}

terraform-apply(){
run_terraform apply plan || true
run_docker /terraform "rm plan"
}

terraform-destroy(){
run_terraform destroy
}

run_kubectl(){
run_docker /k8s-specs kubectl --kubeconfig /terraform/kubeconfig_${KIT_CLUSTER_NAME} ${@}
}

kubectl-apply(){
kubectl-generate
run_kubectl create -f 00_storage_class.yaml || true
run_kubectl create -f 01_olm-0.5.0/ || true
run_kubectl create -f 02_vpn_operator.yaml || true
run_kubectl create -f 03_vpn_cr.yaml || true
}

kubectl-generate(){
	rm -fr $K8S_WORK_DIR || true
	mkdir $K8S_WORK_DIR
	cp -r k8s-specs/* $K8S_WORK_DIR/
	ENV_VAR_PAIRS=$(cat $ENV_SCRIPT)
	for ENV_VAR_PAIR in $ENV_VAR_PAIRS; do
    if grep "#" $ENV_VAR_PAIR;then
      continue
    fi
		ENV_VAR=$(echo $ENV_VAR_PAIR | cut -d '=' -f1)
		MATCHED_FILES=$(grep -R $ENV_VAR $K8S_WORK_DIR/**.yaml | cut -d ':' -f1)
		for MATCHED_FILE in $MATCHED_FILES; do
      sed -i "s/${ENV_VAR}/${!ENV_VAR}/g" $MATCHED_FILE
		done
	done
}

init(){
if [ -z ${1+x} ]; then
  echo "ERROR: You must pass a command";
  echo "Example Usage:"
  echo "kit.sh terraform-plan"
  exit 1;
fi

ENV_SCRIPT=scripts/env.sh
. $ENV_SCRIPT

if [ ! -z "${AWS_PROFILE}" ]; then
	. ./scripts/aws_exporter.sh ${AWS_PROFILE}
fi

: ${AWS_ACCESS_KEY_ID:?"Need to set AWS_ACCESS_KEY_ID env var"}
: ${AWS_SECRET_ACCESS_KEY:?"Need to set AWS_SECRET_ACCESS_KEY env var"}
: ${AWS_DEFAULT_REGION:?"Need to set AWS_DEFAULT_REGION env var"}

K8S_WORK_DIR="$(pwd)/build"
}

init $@

# pass in all subsequent arguments to the function named by the first argument
$1 ${@:2}
