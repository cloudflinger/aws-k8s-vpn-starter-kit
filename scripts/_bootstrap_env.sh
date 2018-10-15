bootstrap-env(){
ENV_SCRIPT=config.sh
. $ENV_SCRIPT

KIT_IMAGE_NAME="aws-k8s-vpn-starter-kit:v1"
WORK_DIR="/workdir"
K8S_TEMPLATES_DIR="k8s-specs"
K8S_OUTPUT_DIR="k8s-specs-output"
}