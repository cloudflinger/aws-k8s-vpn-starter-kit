#!/bin/bash

###########################
#
# This script is designed to
# be run inside the docker
#
##########################

: ${CLUSTER_NAME:?"Need to set CLUSTER_NAME env var"}

export TF_VAR_cluster_name=${CLUSTER_NAME}

cd /terraform
terraform init
terraform plan
