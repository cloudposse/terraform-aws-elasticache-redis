provider "aws" {
  region = var.region
}

module "vpc" {
  source  = "cloudposse/vpc/aws"
  version = "2.2.0"

  ipv4_primary_cidr_block = "172.16.0.0/16"

  context = module.this.context
}

module "subnets" {
  source  = "cloudposse/dynamic-subnets/aws"
  version = "2.4.2"

  availability_zones   = var.availability_zones
  vpc_id               = module.vpc.vpc_id
  igw_id               = [module.vpc.igw_id]
  ipv4_cidr_block      = [module.vpc.vpc_cidr_block]
  nat_gateway_enabled  = false
  nat_instance_enabled = false

  context = module.this.context
}

# Create a zone in order to validate fix for https://github.com/cloudposse/terraform-aws-elasticache-redis/issues/82
resource "aws_route53_zone" "private" {
  name = format("elasticache-redis-terratest-%s.testing.cloudposse.co", try(module.this.attributes[0], "default"))

  vpc {
    vpc_id = module.vpc.vpc_id
  }
}

module "cloudwatch_logs" {
  source  = "cloudposse/cloudwatch-logs/aws"
  version = "0.6.8"

  context = module.this.context
}

module "redis" {
  source = "../../"

  availability_zones               = var.availability_zones
  zone_id                          = [aws_route53_zone.private.id]
  vpc_id                           = module.vpc.vpc_id
  allowed_security_groups          = [module.vpc.vpc_default_security_group_id]
  subnets                          = module.subnets.private_subnet_ids
  cluster_size                     = var.cluster_size
  instance_type                    = var.instance_type
  apply_immediately                = true
  automatic_failover_enabled       = false
  engine_version                   = var.engine_version
  family                           = var.family
  at_rest_encryption_enabled       = var.at_rest_encryption_enabled
  transit_encryption_enabled       = var.transit_encryption_enabled
  cloudwatch_metric_alarms_enabled = var.cloudwatch_metric_alarms_enabled

  # Verify that we can safely change security groups (name changes forces new SG)
  security_group_create_before_destroy = true
  security_group_name                  = length(var.sg_name) > 0 ? [var.sg_name] : []

  parameter = [
    {
      name  = "notify-keyspace-events"
      value = "lK"
    }
  ]

  security_group_delete_timeout = "5m"

  log_delivery_configuration = [
    {
      destination      = module.cloudwatch_logs.log_group_name
      destination_type = "cloudwatch-logs"
      log_format       = "json"
      log_type         = "engine-log"
    }
  ]

  context = module.this.context
}
