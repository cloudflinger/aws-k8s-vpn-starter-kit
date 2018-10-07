#!/bin/bash

###########################
#
# This script is designed to
# be run inside the docker
#
##########################

cd /terraform
terraform init
terraform plan
