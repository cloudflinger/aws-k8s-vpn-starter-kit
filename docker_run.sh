#!/bin/bash
docker run --rm --env-file ./docker_env.list --mount src="$(pwd)/terraform",target=/terraform,type=bind -it eks-starter-kit:v1
