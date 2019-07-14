provider "aws" {
  region = var.region
}

module "vpc" {
  source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=tags/0.7.0"
  namespace  = var.namespace
  stage      = var.stage
  name       = var.name
  cidr_block = "172.16.0.0/16"
}

module "subnets" {
  source               = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=tags/0.16.0"
  availability_zones   = var.availability_zones
  namespace            = var.namespace
  stage                = var.stage
  name                 = var.name
  vpc_id               = module.vpc.vpc_id
  igw_id               = module.vpc.igw_id
  cidr_block           = module.vpc.vpc_cidr_block
  nat_gateway_enabled  = true
  nat_instance_enabled = false
}

module "redis" {
  source                     = "../../"
  availability_zones         = var.availability_zones
  namespace                  = var.namespace
  stage                      = var.stage
  name                       = var.name
  zone_id                    = var.zone_id
  vpc_id                     = module.vpc.vpc_id
  security_groups            = [module.vpc.vpc_default_security_group_id]
  subnets                    = module.subnets.private_subnet_ids
  cluster_size               = var.cluster_size
  instance_type              = var.instance_type
  apply_immediately          = true
  automatic_failover         = false
  engine_version             = var.engine_version
  family                     = var.family
  at_rest_encryption_enabled = var.at_rest_encryption_enabled
  transit_encryption_enabled = var.transit_encryption_enabled

  parameter = [
    {
      name  = "notify-keyspace-events"
      value = "lK"
    }
  ]
}
