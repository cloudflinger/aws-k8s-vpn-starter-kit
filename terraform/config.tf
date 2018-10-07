data "aws_availability_zones" "available" {}

locals {
  azs              = ["${data.aws_availability_zones.available.names}"]
}
