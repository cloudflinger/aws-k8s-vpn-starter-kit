data "aws_availability_zones" "available" {}

locals {
  azs              = ["${data.aws_availability_zones.available.names}"]
  environment_name = "prod"
  vpc_cidr         = "10.1.0.0/16"
  vpc_name         = "my-vpc"
  aws_region = "us-west-2"
}
