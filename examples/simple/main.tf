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

variable "namespace" {}

variable "name" {}

variable "stage" {}

variable "region" {}

variable "availability_zones" {
  type = "list"
}

variable "zone_id" {}

module "vpc" {
  source    = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=master"
  namespace = "${var.namespace}"
  stage     = "${var.stage}"
  name      = "${var.name}"
}

module "subnets" {
  source             = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=master"
  namespace          = "${var.namespace}"
  stage              = "${var.stage}"
  name               = "${var.name}"
  region             = "${var.region}"
  availability_zones = "${var.availability_zones}"
  vpc_id             = "${module.vpc.vpc_id}"
  igw_id             = "${module.vpc.igw_id}"
  cidr_block         = "10.0.0.0/16"
}

module "redis" {
  source             = "../../"
  namespace          = "${var.namespace}"
  stage              = "${var.stage}"
  name               = "${var.name}"
  zone_id            = "${var.zone_id}"
  vpc_id             = "${module.vpc.vpc_id}"
  subnets            = "${module.subnets.private_subnet_ids}"
  maintenance_window = "wed:03:00-wed:04:00"
  cluster_size       = "2"
  instance_type      = "cache.t2.micro"
  apply_immediately  = "true"
  availability_zones = "${var.availability_zones}"
  automatic_failover = "false"

  engine_version               = "4.0.10"
  family                       = "redis4.0"
  port                         = "6379"
  alarm_cpu_threshold_percent  = "75"
  alarm_memory_threshold_bytes = "10000000"
  at_rest_encryption_enabled   = "true"

  parameter = [
    {
      name  = "notify-keyspace-events"
      value = "lK"
    },
  ]
}
