module "redis_security_group" {
  source = "git@github.com:opploans/terraform-aws-security-group.git?ref=v1.2.0"

  environment     = var.environment
  application     = var.application
  owner           = var.owner
  repo            = var.repo
  repo_path       = var.repo_path
  aws_profile     = var.aws_profile
  aws_region      = var.aws_region
  additional_tags = var.additional_tags

  name_suffix   = "redis"
  egress_rules  = var.sg_egress_rules
  ingress_rules = var.sg_ingress_rules
}

resource "aws_elasticache_subnet_group" "default" {
  name       = local.resource_name
  subnet_ids = module.data_environment.data_subnets_ids
}

resource "aws_elasticache_parameter_group" "default" {
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
  auth_token                    = var.auth_token
  replication_group_id          = local.resource_name
  replication_group_description = local.resource_name
  node_type                     = var.instance_type
  number_cache_clusters         = var.cluster_mode_enabled ? null : var.cluster_size
  port                          = var.port
  parameter_group_name          = aws_elasticache_parameter_group.default.name
  automatic_failover_enabled    = var.automatic_failover_enabled
  subnet_group_name             = aws_elasticache_subnet_group.default.name
  security_group_ids            = module.redis_security_group.security_group_ids_including_all_instances
  maintenance_window            = var.maintenance_window
  notification_topic_arn        = var.notification_topic_arn
  engine_version                = var.engine_version
  at_rest_encryption_enabled    = true
  transit_encryption_enabled    = true
  snapshot_window               = var.snapshot_window
  snapshot_retention_limit      = var.snapshot_retention_limit
  apply_immediately             = var.apply_immediately

  tags = local.tags
  provisioner "local-exec" {
    environment = {
      REPLICATION_GROUP_ID = aws_elasticache_replication_group.default.replication_group_id
      AWS_PROFILE = var.aws_profile
    }
    command = <<-EOT
      AWS_PROFILE=$AWS_PROFILE \
      aws elasticache modify-replication-group \
        --replication-group-id $REPLICATION_GROUP_ID \
        --multi-az-enabled \
        --apply-immediately \
        --region var.aws_region
    EOT
    }

  dynamic "cluster_mode" {
    for_each = var.cluster_mode_enabled ? ["true"] : []
    content {
      replicas_per_node_group = var.cluster_mode_replicas_per_node_group
      num_node_groups         = var.cluster_mode_num_node_groups
    }
  }

  lifecycle {
    ignore_changes = [auth_token]
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
  zone_id = module.data_environment.main_route53_zone_id
  name    = coalesce(var.redis_hostname, "${var.application}-redis")
  type    = "CNAME"
  ttl     = 300
  records = [var.cluster_mode_enabled ? aws_elasticache_replication_group.default.configuration_endpoint_address : aws_elasticache_replication_group.default.primary_endpoint_address]
}
