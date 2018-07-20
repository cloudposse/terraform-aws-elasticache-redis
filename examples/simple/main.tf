terraform {
  required_version = ">= 0.11.2"

  backend "s3" {}
}

variable "aws_assume_role_arn" {}

provider "aws" {
  assume_role {
    role_arn = "${var.aws_assume_role_arn}"
  }
}

variable "region" {
  default = "us-west-2"
}

variable "availability_zones" {
  default = ["us-west-2a", "us-west-2b"]
}

module "vpc" {
  source    = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=tags/0.3.3"
  namespace = "eg"
  stage     = "testing"
  name      = "redis"
}

module "subnets" {
  source             = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=tags/0.3.5"
  namespace          = "eg"
  stage              = "testing"
  name               = "redis"
  region             = "${var.region}"
  availability_zones = "${var.availability_zones}"
  vpc_id             = "${module.vpc.vpc_id}"
  igw_id             = "${module.vpc.igw_id}"
  cidr_block         = "10.0.0.0/16"
}

module "redis" {
  source    = "../../"
  namespace = "eg"
  name      = "redis"
  stage     = "testing"
#  zone_id   = "${var.route53_zone_id}"

  vpc_id             = "${module.vpc.vpc_id}"
  subnets            = "${module.subnets.private_subnet_ids}"
  maintenance_window = "wed:03:00-wed:04:00"
  cluster_size       = "2"
  instance_type      = "cache.t2.micro"
  apply_immediately  = "true"
  availability_zones = "${var.availability_zones}"

  automatic_failover = "false"
}
