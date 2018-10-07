module "eks" {
  source       = "terraform-aws-modules/eks/aws"
  cluster_name = "${var.cluster_name}"
  subnets      = ["${module.vpc.private_subnets}"]

  tags = {
    Environment = "test"
    Terraform   = "true"
  }

  vpc_id = "${module.vpc.vpc_id}"
}
