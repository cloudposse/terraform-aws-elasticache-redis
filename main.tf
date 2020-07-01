#
# Security Group Resources
#
resource "aws_security_group" "default" {
  count  = var.enabled && var.use_existing_security_groups == false ? 1 : 0
  vpc_id = var.vpc_id
  name   = local.resource_name
  tags   = local.tags
}

resource "aws_security_group_rule" "egress" {
  count             = var.enabled && var.use_existing_security_groups == false ? 1 : 0
  description       = "Allow all egress traffic"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = join("", aws_security_group.default.*.id)
  type              = "egress"
}

resource "aws_security_group_rule" "ingress_security_groups" {
  count                    = var.enabled && var.use_existing_security_groups == false ? length(var.allowed_security_groups) : 0
  description              = "Allow inbound traffic from existing Security Groups"
  from_port                = var.port
  to_port                  = var.port
  protocol                 = "tcp"
  source_security_group_id = var.allowed_security_groups[count.index]
  security_group_id        = join("", aws_security_group.default.*.id)
  type                     = "ingress"
}

resource "aws_security_group_rule" "ingress_cidr_blocks" {
  count             = var.enabled && var.use_existing_security_groups == false && length(var.allowed_cidr_blocks) > 0 ? 1 : 0
  description       = "Allow inbound traffic from CIDR blocks"
  from_port         = var.port
  to_port           = var.port
  protocol          = "tcp"
  cidr_blocks       = var.allowed_cidr_blocks
  security_group_id = join("", aws_security_group.default.*.id)
  type              = "ingress"
}

resource "aws_elasticache_subnet_group" "default" {
  count      = var.enabled && var.elasticache_subnet_group_name == "" && length(var.subnet_ids) > 0 ? 1 : 0
  name       = local.resource_name
  subnet_ids = var.subnet_ids
}

resource "aws_elasticache_parameter_group" "default" {
  count  = var.enabled ? 1 : 0
  name   = local.resource_name
  family = var.family



  dynamic "parameter" {
    for_each = var.cluster_mode_enabled ? concat([{ "name" = "cluster-enabled", "value" = "yes" }], var.parameter) : var.parameter
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }
}

resource "aws_elasticache_replication_group" "default" {
  count = var.enabled ? 1 : 0

  auth_token                    = var.transit_encryption_enabled ? var.auth_token : null
  replication_group_id          = local.resource_name
  replication_group_description = local.resource_name
  node_type                     = var.instance_type
  number_cache_clusters         = var.cluster_mode_enabled ? null : var.cluster_size
  port                          = var.port
  parameter_group_name          = aws_elasticache_parameter_group.default[0].name
  availability_zones            = var.availability_zones
  automatic_failover_enabled    = var.automatic_failover_enabled
  subnet_group_name             = aws_elasticache_subnet_group.default[0].name
  security_group_ids            = var.use_existing_security_groups ? var.existing_security_groups : [join("", aws_security_group.default.*.id)]
  maintenance_window            = var.maintenance_window
  notification_topic_arn        = var.notification_topic_arn
  engine_version                = var.engine_version
  at_rest_encryption_enabled    = var.at_rest_encryption_enabled
  transit_encryption_enabled    = var.transit_encryption_enabled
  snapshot_window               = var.snapshot_window
  snapshot_retention_limit      = var.snapshot_retention_limit
  apply_immediately             = var.apply_immediately

  tags = local.tags

  dynamic "cluster_mode" {
    for_each = var.cluster_mode_enabled ? ["true"] : []
    content {
      replicas_per_node_group = var.cluster_mode_replicas_per_node_group
      num_node_groups         = var.cluster_mode_num_node_groups
    }
  }
}

resource "aws_sns_topic" "cloudwatch" {
  name         = local.resource_name
  display_name = local.resource_name
}

resource "aws_sns_topic_subscription" "cloudwatch" {
  endpoint               = var.subscription_pagerduty_endpoint
  protocol               = "https"
  topic_arn              = aws_sns_topic.cloudwatch.arn
  endpoint_auto_confirms = true
  depends_on             = [aws_sns_topic.cloudwatch]
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_high" {
  alarm_name                = format("%s-%s", local.resource_name, "cpu-high")
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = var.cpu_utilization_high_evaluation_periods
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/ElastiCache"
  period                    = var.cpu_utilization_high_period
  statistic                 = "Average"
  threshold                 = max(var.cpu_utilization_high_threshold, 0)
  alarm_actions             = [aws_sns_topic.cloudwatch.arn]
  ok_actions                = [aws_sns_topic.cloudwatch.arn]
  insufficient_data_actions = [aws_sns_topic.cloudwatch.arn]

  dimensions = {
    CacheClusterId = local.resource_name
  }
}

resource "aws_cloudwatch_metric_alarm" "memory_utilization_high" {
  alarm_name                = format("%s-%s", local.resource_name, "memory-high")
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = var.memory_utilization_high_evaluation_periods
  metric_name               = "MemoryUtilization"
  namespace                 = "AWS/ElastiCache"
  period                    = var.memory_utilization_high_period
  statistic                 = "Average"
  threshold                 = max(var.memory_utilization_high_threshold, 0)
  alarm_actions             = [aws_sns_topic.cloudwatch.arn]
  ok_actions                = [aws_sns_topic.cloudwatch.arn]
  insufficient_data_actions = [aws_sns_topic.cloudwatch.arn]

  dimensions = {
    CacheClusterId = local.resource_name
  }
}

resource "aws_route53_record" "redis" {
  zone_id = var.zone_id
  name    = var.redis_fqdn != "" ? var.redis_fqdn : "${var.application}-redis"
  type    = "CNAME"
  ttl     = 300
  records = var.cluster_mode_enabled ? aws_elasticache_replication_group.default.*.configuration_endpoint_address : aws_elasticache_replication_group.default.*.primary_endpoint_address

  lifecycle {
    create_before_destroy = true
  }
}
