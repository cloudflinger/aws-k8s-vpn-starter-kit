current_dir = $(PWD)
kit_image_name="aws-k8s-vpn-starter-kit:v1"

.PHONY: docker-build-kit

default: docker-build-kit env terraform-apply terraform-destroy terraform-plan

docker-build-kit:
	@echo "Building the docker tool kit"
	docker build -t $(kit_image_name) .

terraform-plan:
	./scripts/kit.sh terraform-plan

terraform-apply:
	./scripts/kit.sh terraform-apply

terraform-destroy:
	./scripts/kit.sh terraform-destroy

kubectl-apply:
	./scripts/kit.sh kubectl-apply

kubectl-echo:
	./scripts/kit.sh kubectl-echo
