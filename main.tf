# Define composite variables for resources
module "label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.13.0"
  enabled    = var.enabled
  namespace  = var.namespace
  name       = var.name
  stage      = var.stage
  delimiter  = var.delimiter
  attributes = var.attributes
  tags       = var.tags
}

#
# Security Group Resources
#
resource "aws_security_group" "default" {
  count  = var.enabled == "true" ? 1 : 0
  vpc_id = var.vpc_id
  name   = module.label.id

  ingress {
    from_port       = var.port # Redis
    to_port         = var.port
    protocol        = "tcp"
    security_groups = var.security_groups
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = module.label.tags
}

locals {
  elasticache_subnet_group_name = var.elasticache_subnet_group_name != "" ? var.elasticache_subnet_group_name : join("", aws_elasticache_subnet_group.default.*.name)
}

resource "aws_elasticache_subnet_group" "default" {
  count      = var.enabled == "true" && var.elasticache_subnet_group_name == "" && length(var.subnets) > 0 ? 1 : 0
  name       = module.label.id
  subnet_ids = var.subnets
}

resource "aws_elasticache_parameter_group" "default" {
  count  = var.enabled == "true" ? 1 : 0
  name   = module.label.id
  family = var.family
  dynamic "parameter" {
    for_each = var.parameter
    content {
      # TF-UPGRADE-TODO: The automatic upgrade tool can't predict
      # which keys might be set in maps assigned here, so it has
      # produced a comprehensive set here. Consider simplifying
      # this after confirming which keys can be set in practice.

      name  = parameter.value.name
      value = parameter.value.value
    }
  }
}

resource "aws_elasticache_replication_group" "default" {
  count = var.enabled == "true" ? 1 : 0

  auth_token                    = var.auth_token
  replication_group_id          = var.replication_group_id == "" ? module.label.id : var.replication_group_id
  replication_group_description = module.label.id
  node_type                     = var.instance_type
  number_cache_clusters         = var.cluster_size
  port                          = var.port
  parameter_group_name          = aws_elasticache_parameter_group.default[0].name
  availability_zones            = slice(var.availability_zones, 0, var.cluster_size)
  automatic_failover_enabled    = var.automatic_failover
  subnet_group_name             = local.elasticache_subnet_group_name
  security_group_ids            = [aws_security_group.default[0].id]
  maintenance_window            = var.maintenance_window
  notification_topic_arn        = var.notification_topic_arn
  engine_version                = var.engine_version
  at_rest_encryption_enabled    = var.at_rest_encryption_enabled
  transit_encryption_enabled    = var.transit_encryption_enabled

  tags = module.label.tags
}

#
# CloudWatch Resources
#
resource "aws_cloudwatch_metric_alarm" "cache_cpu" {
  count               = var.enabled == "true" ? 1 : 0
  alarm_name          = "${module.label.id}-cpu-utilization"
  alarm_description   = "Redis cluster CPU utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = "300"
  statistic           = "Average"

  threshold = var.alarm_cpu_threshold_percent

  dimensions = {
    CacheClusterId = module.label.id
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions
  depends_on    = [aws_elasticache_replication_group.default]
}

resource "aws_cloudwatch_metric_alarm" "cache_memory" {
  count               = var.enabled == "true" ? 1 : 0
  alarm_name          = "${module.label.id}-freeable-memory"
  alarm_description   = "Redis cluster freeable memory"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/ElastiCache"
  period              = "60"
  statistic           = "Average"

  threshold = var.alarm_memory_threshold_bytes

  dimensions = {
    CacheClusterId = module.label.id
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions
  depends_on    = [aws_elasticache_replication_group.default]
}

module "dns" {
  source    = "git::https://github.com/rverma-nikiai/terraform-aws-route53-cluster-hostname.git?ref=master"
  enabled   = var.enabled == "true" && length(var.zone_id) > 0 ? "true" : "false"
  namespace = var.namespace
  name      = var.name
  stage     = var.stage
  ttl       = 60
  zone_id   = var.zone_id
  records   = [aws_elasticache_replication_group.default.*.primary_endpoint_address]
}

