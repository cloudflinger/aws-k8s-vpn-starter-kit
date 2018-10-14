#!/bin/bash

set -x
set -e

run_docker(){
if [ ! -d "${K8S_WORK_DIR}" ]; then
	mkdir ${K8S_WORK_DIR}
fi
docker run --rm \
--mount src="$(pwd)/terraform",target=/terraform,type=bind \
--mount src="$(pwd)/k8s-specs",target=/k8s-specs-templates,type=bind \
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

kubectl-destroy(){
kubectl-generate
run_kubectl delete -f 03_vpn_cr.yaml || true
run_kubectl delete -f 02_vpn_operator.yaml || true
run_kubectl delete -f 01_olm-0.5.0/ || true
run_kubectl delete -f 00_storage_class.yaml || true
}

kubectl-generate(){
rm -fr $K8S_WORK_DIR || true
mkdir $K8S_WORK_DIR
cp -r k8s-specs/* $K8S_WORK_DIR/
cat $ENV_SCRIPT | while read ENV_VAR_PAIR;do
    if echo $ENV_VAR_PAIR | grep "^#";then
      continue
    fi
	ENV_VAR=$(echo $ENV_VAR_PAIR | cut -d '=' -f1)
	ENV_VAR_VALUE=${!ENV_VAR}
	echo "ENV VAR ${ENV_VAR}=${ENV_VAR_VALUE}"
	MATCHED_FILES=$(run_docker /k8s-specs grep -R $ENV_VAR ./**.yaml | cut -d ':' -f1)
	echo ${MATCHED_FILES}
# 	# for MATCHED_FILE in $MATCHED_FILES; do
# 	# 	sed-replacement "${ENV_VAR}" "${!ENV_VAR}" "${MATCHED_FILE}"
# 	# done
done
}

sed-replacement(){
KEY=$1
VALUE=$2
FILENAME=$3
run_docker /k8s-specs-templates sed -i "s/${KEY}/${VALUE}/g" $FILENAME
}

vpn-create-config(){
	# TODO: fix this whole thing. it should get all it's values from elsewhere and just be runable from docker to get the config file onto the local filesystem
	if [ $# -ne 3 ]
	then
	  echo "Usage: $0 <CLIENT_KEY_NAME> <NAMESPACE> <HELM_RELEASE>"
	  exit
	fi

	KEY_NAME=$1
	NAMESPACE=$2
	HELM_RELEASE=$3
	POD_NAME=$(run_kubectl get pods -n "${NAMESPACE}" -l "app=openvpn,release=${HELM_RELEASE}" -o jsonpath='{.items[0].metadata.name}')
	SERVICE_NAME=$(run_kubectl get svc -n "${NAMESPACE}" -l "app=openvpn,release=${HELM_RELEASE}" -o jsonpath='{.items[0].metadata.name}')
	SERVICE_IP=$(run_kubectl get svc -n "${NAMESPACE}" "${SERVICE_NAME}" -o=jsonpath='{.status.loadBalancer.ingress[0].hostname}')
	run_kubectl -n "${NAMESPACE}" exec -it "${POD_NAME}" /etc/openvpn/setup/newClientConfig.sh "${KEY_NAME}" "${SERVICE_IP}"
	run_kubectl -n "${NAMESPACE}" exec -it "${POD_NAME}" -- cat "/etc/openvpn/${KEY_NAME}.ovpn" > "${KEY_NAME}.ovpn"
	echo "the config file exists at ${KEY_NAME}.ovpn"
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
