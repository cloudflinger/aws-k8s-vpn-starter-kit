bootstrap-env(){
ENV_SCRIPT=config.sh
if [ ! -f $ENV_SCRIPT ]; then
  cp ${ENV_SCRIPT}.sample $ENV_SCRIPT
  echo "####################"
  echo "####################"
  echo "ATTENTION!"
  echo "FIRST TIME CONFIG!"
  echo "Set values in config.sh before continuing!"
  exit 0
fi

. $ENV_SCRIPT

KIT_IMAGE_NAME="aws-k8s-vpn-starter-kit:v1"
WORK_DIR="/workdir"
K8S_TEMPLATES_DIR="k8s-specs"
K8S_OUTPUT_DIR="k8s-specs-output"
}
