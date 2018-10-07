#!/bin/bash
: ${AWS_ACCESS_KEY_ID:?"Need to set AWS_ACCESS_KEY_ID env var"}
: ${AWS_SECRET_ACCESS_KEY:?"Need to set AWS_SECRET_ACCESS_KEY env var"}
: ${AWS_DEFAULT_REGION:?"Need to set AWS_DEFAULT_REGION env var"}

docker run --rm \
--mount src="$(pwd)/terraform",target=/terraform,type=bind \
--mount src="$(pwd)/k8s-specs",target=/k8s-specs,type=bind \
--env-file ./docker_env.list \
--env AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
--env AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
--env AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION} \
-it aws-k8s-vpn-starter-kit:v1
