#!/bin/bash

#####
## THIS FILE RUNS WITHIN THE DOCKER CONTAINER ONLY
## So it should be written in terms of the container filesystem
####

set +x
set -e

run_terraform(){
pushd terraform
terraform ${@}
popd
}

terraform-init(){
run_terraform init
}

terraform-plan(){
run_terraform plan -out plan
}

terraform-apply(){
run_terraform apply plan || true
rm /terraform/plan
}

terraform-destroy(){
# kubectl-destroy
run_terraform destroy
}

run_kubectl(){
pushd ${K8S_OUTPUT_DIR}
kubectl --kubeconfig /workdir/terraform/kubeconfig_${KIT_CLUSTER_NAME} ${@}
popd
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
pushd k8s-specs-output/
run_kubectl delete -f 03_vpn_cr.yaml || true
run_kubectl delete -f 02_vpn_operator.yaml || true
run_kubectl delete -f 01_olm-0.5.0/ || true
run_kubectl delete -f 00_storage_class.yaml || true
popd
}

kubectl-generate(){
rm -fr ${K8S_OUTPUT_DIR} || true
mkdir ${K8S_OUTPUT_DIR}
cp -r ${K8S_TEMPLATES_DIR}/* ${K8S_OUTPUT_DIR}/
cat ${ENV_SCRIPT} | while read ENV_VAR_PAIR;do
    if echo ${ENV_VAR_PAIR} | grep "^#";then
      continue
    fi
	ENV_VAR=$(echo ${ENV_VAR_PAIR} | cut -d '=' -f1)
	ENV_VAR_VALUE=${!ENV_VAR}
	MATCHED_FILES=$(grep -R ${ENV_VAR} ${K8S_OUTPUT_DIR}/**.yaml | cut -d ':' -f1)
    for MATCHED_FILE in ${MATCHED_FILES}; do
		sed -i "s/${ENV_VAR}/${!ENV_VAR}/g" ${MATCHED_FILE}
    done
done
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

. ./scripts/_bootstrap_env.sh
bootstrap-env
$1 {$@:2}
