module "eks" {
  source       = "terraform-aws-modules/eks/aws"
  cluster_name = "${local.cluster_name}"
  subnets      = "${concat(module.vpc.private_subnets, module.vpc.public_subnets)}"

  tags = {
    Environment = "test"
    Terraform   = "true"
  }

  vpc_id = "${module.vpc.vpc_id}"

  kubeconfig_name = "${var.cluster_name}"
}
