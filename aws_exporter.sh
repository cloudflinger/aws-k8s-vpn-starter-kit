#!/bin/bash

# USAGE
# . aws_exporter.sh MYPROFILE

PROFILE_NAME=$1
export AWS_ACCESS_KEY_ID=$(aws configure get ${PROFILE_NAME}.aws_access_key_id)
export AWS_SECRET_ACCESS_KEY=$(aws configure get ${PROFILE_NAME}.aws_secret_access_key)
export AWS_DEFAULT_REGION=$(aws configure get ${PROFILE_NAME}.region)
