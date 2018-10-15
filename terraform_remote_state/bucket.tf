resource "aws_s3_bucket" "config" {
  provider = "aws"
  bucket   = "${var.cfg_bucket}"
  acl      = "private"
  region   = "${var.remote_state_region}"

  #tags {
  #  Environment = "Dev"
  #}

  versioning {
    enabled = true
  }
}
