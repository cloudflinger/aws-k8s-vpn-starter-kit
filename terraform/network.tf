module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${local.vpc_name}"
  cidr = "${local.vpc_cidr}"

  azs = "${local.azs}"

  private_subnets = [
    "${cidrsubnet(local.vpc_cidr, 5, 0)}",
    "${cidrsubnet(local.vpc_cidr, 5, 1)}",
    "${cidrsubnet(local.vpc_cidr, 5, 2)}",
  ]

  public_subnets = [
    "${cidrsubnet(local.vpc_cidr, 5, 3)}",
    "${cidrsubnet(local.vpc_cidr, 5, 4)}",
    "${cidrsubnet(local.vpc_cidr, 5, 5)}",
  ]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "${local.environment_name}"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

  vpc_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}
