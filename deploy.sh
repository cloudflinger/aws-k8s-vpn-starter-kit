#!/bin/bash

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
: ${AWS_DEFAULT_REGION:?"Need to set AWS_DEFAULT_REGION env var"}

export TF_VAR_cluster_name=${CLUSTER_NAME}
export TF_VAR_environment_name=${ENVIRONMENT_NAME}
export TF_VAR_vpc_cidr=${VPC_CIDR}
export TF_VAR_vpc_name=${VPC_NAME}
export TF_VAR_aws_region=${AWS_DEFAULT_REGION}

cd /terraform
terraform init
terraform plan

#cd /k8s-specs
#kubectl -f 00_storage_class.yaml
#for SPEC in $(ls -1 01_olm*);do kubectl -f $SPEC;done
#kubectl -f 02_vpn_operator.yaml
#kubectl -f 03_vpn_cr.yaml
