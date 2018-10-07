#!/bin/bash
docker run --rm \
--env-file ./docker_env.list \
--mount src="$(pwd)/terraform",target=/terraform,type=bind \
--env AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
--env AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
--env AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION} \
-it eks-starter-kit:v1
