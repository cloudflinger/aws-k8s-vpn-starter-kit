#!/bin/bash

###### 
## Helper Script to convert aws profile into access key id, secret access key, and region
######

if [ -z ${1+x} ]; then 
  echo "ERROR: You must pass a profile name"; 
  echo "Example Usage:"
  echo "source aws_exporter.sh MY_PROFILE"
  exit 1;
fi
PROFILE_NAME=$1

# USAGE
# . aws_exporter.sh MYPROFILE

export AWS_ACCESS_KEY_ID=$(aws configure get ${PROFILE_NAME}.aws_access_key_id)
export AWS_SECRET_ACCESS_KEY=$(aws configure get ${PROFILE_NAME}.aws_secret_access_key)
export AWS_DEFAULT_REGION=$(aws configure get ${PROFILE_NAME}.region)
