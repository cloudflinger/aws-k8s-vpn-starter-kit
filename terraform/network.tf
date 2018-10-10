module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.vpc_name}"
  cidr = "${var.vpc_cidr}"

  azs = "${local.azs}"

  private_subnets = [
    "${cidrsubnet(var.vpc_cidr, 5, 0)}",
    "${cidrsubnet(var.vpc_cidr, 5, 1)}",
    "${cidrsubnet(var.vpc_cidr, 5, 2)}",
  ]

  public_subnets = [
    "${cidrsubnet(var.vpc_cidr, 5, 3)}",
    "${cidrsubnet(var.vpc_cidr, 5, 4)}",
    "${cidrsubnet(var.vpc_cidr, 5, 5)}",
  ]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "${var.environment_name}"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  vpc_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }
}
