current_dir = $(PWD)

.PHONY: docker-build-kit

default: docker-build-kit terraform-apply terraform-destroy terraform-plan

docker-build-kit:
	@echo "Building the docker tool kit"
	./scripts/docker-entry.sh docker-build-kit

terraform-init:
	./scripts/docker-entry.sh terraform-init

terraform-plan:
	./scripts/docker-entry.sh terraform-plan

terraform-apply:
	./scripts/docker-entry.sh terraform-apply

terraform-destroy:
	./scripts/docker-entry.sh terraform-destroy

kubectl-apply:
	./scripts/docker-entry.sh kubectl-apply

vpn-init:
	./scripts/docker-entry.sh kubectl-apply

kubectl-generate:
	./scripts/docker-entry.sh kubectl-generate
