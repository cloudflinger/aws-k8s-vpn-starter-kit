data "aws_availability_zones" "available" {}

locals {
  azs          = ["${data.aws_availability_zones.available.names}"]
  cluster_name = "${var.cluster_name}-${random_string.cluster_suffix.result}"
}

provider "random" {
  version = "= 1.3.1"
}

resource "random_string" "cluster_suffix" {
  length  = 8
  special = false
}
