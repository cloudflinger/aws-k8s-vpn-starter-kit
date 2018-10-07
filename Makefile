current_dir = $(PWD)
kit_image_name="aws-k8s-vpn-starter-kit:v1"

.PHONY: docker-build-kit

default: docker-build-kit env terraform-apply terraform-destroy terraform-plan

docker-build-kit:
	@echo "Building the docker tool kit"
	docker build -t $(kit_image_name) .

env:
	source aws_exporter.sh ${AWS_PROFILE}

terraform-apply:
	@echo "pwd:${current_dir}"
	@echo "image:${kit_image_name}"
	docker run --rm \
		--mount src="${current_dir}/terraform",target=/terraform,type=bind \
		--mount src="${current_dir}/k8s-specs",target=/k8s-specs,type=bind \
		--env-file ./docker_env.list \
		--env AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
		--env AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
		--env AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION} \
		--workdir /terraform \
		${kit_image_name} \
		terraform apply plan.out

terraform-destroy:
	@echo "pwd:${current_dir}"
	@echo "image:${kit_image_name}"
	docker run --rm \
		--mount src="${current_dir}/terraform",target=/terraform,type=bind \
		--mount src="${current_dir}/k8s-specs",target=/k8s-specs,type=bind \
		--env-file ./docker_env.list \
		--env AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
		--env AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
		--env AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION} \
		--env TF_VAR_aws_region=${AWS_DEFAULT_REGION} \
		--env TF_VAR_cluster_name="jake-cluster" \
		--env TF_VAR_environment_name="jake-ville" \
		--env TF_VAR_vpc_cidr="10.12.0.0/16" \
		--env TF_VAR_vpc_name="jake-vpc" \
		--workdir /terraform \
		${kit_image_name} \
		terraform destroy -auto-approve

terraform-plan:
	@echo "pwd:${current_dir}"
	@echo "image:${kit_image_name}"
	docker run --rm \
		--mount src="${current_dir}/terraform",target=/terraform,type=bind \
		--mount src="${current_dir}/k8s-specs",target=/k8s-specs,type=bind \
		--env-file ./docker_env.list \
		--env AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
		--env AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
		--env AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION} \
		--env TF_VAR_aws_region=${AWS_DEFAULT_REGION} \
		--env TF_VAR_cluster_name="jake-cluster" \
		--env TF_VAR_environment_name="jake-ville" \
		--env TF_VAR_vpc_cidr="10.12.0.0/16" \
		--env TF_VAR_vpc_name="jake-vpc" \
		--workdir /terraform \
		${kit_image_name} \
		terraform plan -out plan.out


# export AWS_ACCESS_KEY_ID=$(aws configure get ${PROFILE_NAME}.aws_access_key_id)
# export AWS_SECRET_ACCESS_KEY=$(aws configure get ${PROFILE_NAME}.aws_secret_access_key)
# export AWS_DEFAULT_REGION=$(aws configure get ${PROFILE_NAME}.region)
