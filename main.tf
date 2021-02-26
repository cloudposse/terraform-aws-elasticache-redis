#
# Security Group Resources
#
resource "aws_security_group" "default" {
  count  = module.this.enabled && var.use_existing_security_groups == false ? 1 : 0
  vpc_id = var.vpc_id
  name   = module.this.id
  tags   = module.this.tags
}

resource "aws_security_group_rule" "egress" {
  count             = module.this.enabled && var.use_existing_security_groups == false ? 1 : 0
  description       = "Allow outbound traffic from existing cidr blocks"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = var.egress_cidr_blocks
  security_group_id = join("", aws_security_group.default.*.id)
  type              = "egress"
}

resource "aws_security_group_rule" "ingress_security_groups" {
  count                    = module.this.enabled && var.use_existing_security_groups == false ? length(var.allowed_security_groups) : 0
  description              = "Allow inbound traffic from existing Security Groups"
  from_port                = var.port
  to_port                  = var.port
  protocol                 = "tcp"
  source_security_group_id = var.allowed_security_groups[count.index]
  security_group_id        = join("", aws_security_group.default.*.id)
  type                     = "ingress"
}

resource "aws_security_group_rule" "ingress_cidr_blocks" {
  count             = module.this.enabled && var.use_existing_security_groups == false && length(var.allowed_cidr_blocks) > 0 ? 1 : 0
  description       = "Allow inbound traffic from CIDR blocks"
  from_port         = var.port
  to_port           = var.port
  protocol          = "tcp"
  cidr_blocks       = var.allowed_cidr_blocks
  security_group_id = join("", aws_security_group.default.*.id)
  type              = "ingress"
}

locals {
  elasticache_subnet_group_name = var.elasticache_subnet_group_name != "" ? var.elasticache_subnet_group_name : join("", aws_elasticache_subnet_group.default.*.name)

  # if !cluster, then node_count = replica cluster_size, if cluster then node_count = shard*(replica + 1)
  # Why doing this 'The "count" value depends on resource attributes that cannot be determined until apply'. So pre-calculating
  member_clusters_count = (var.cluster_mode_enabled
    ?
    (var.cluster_mode_num_node_groups * (var.cluster_mode_replicas_per_node_group + 1))
    :
    var.cluster_size
  )

  elasticache_member_clusters = module.this.enabled ? tolist(aws_elasticache_replication_group.default.0.member_clusters) : []
}

resource "aws_elasticache_subnet_group" "default" {
  count      = module.this.enabled && var.elasticache_subnet_group_name == "" && length(var.subnets) > 0 ? 1 : 0
  name       = module.this.id
  subnet_ids = var.subnets
}

resource "aws_elasticache_parameter_group" "default" {
  count  = module.this.enabled ? 1 : 0
  name   = module.this.id
  family = var.family

  dynamic "parameter" {
    for_each = var.cluster_mode_enabled ? concat([{ name = "cluster-enabled", value = "yes" }], var.parameter) : var.parameter
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }
}

resource "aws_elasticache_replication_group" "default" {
  count = module.this.enabled ? 1 : 0

  auth_token                    = var.transit_encryption_enabled ? var.auth_token : null
  replication_group_id          = var.replication_group_id == "" ? module.this.id : var.replication_group_id
  replication_group_description = module.this.id
  node_type                     = var.instance_type
  number_cache_clusters         = var.cluster_mode_enabled ? null : var.cluster_size
  port                          = var.port
  parameter_group_name          = join("", aws_elasticache_parameter_group.default.*.name)
  availability_zones            = length(var.availability_zones) == 0 ? null : [for n in range(0, var.cluster_size) : element(var.availability_zones, n)]
  automatic_failover_enabled    = var.automatic_failover_enabled
  multi_az_enabled              = var.multi_az_enabled
  subnet_group_name             = local.elasticache_subnet_group_name
  security_group_ids            = var.use_existing_security_groups ? var.existing_security_groups : [join("", aws_security_group.default.*.id)]
  maintenance_window            = var.maintenance_window
  notification_topic_arn        = var.notification_topic_arn
  engine_version                = var.engine_version
  at_rest_encryption_enabled    = var.at_rest_encryption_enabled
  transit_encryption_enabled    = var.auth_token != null ? coalesce(true, var.transit_encryption_enabled) : var.transit_encryption_enabled
  kms_key_id                    = var.at_rest_encryption_enabled ? var.kms_key_id : null
  snapshot_name                 = var.snapshot_name
  snapshot_arns                 = var.snapshot_arns
  snapshot_window               = var.snapshot_window
  snapshot_retention_limit      = var.snapshot_retention_limit
  apply_immediately             = var.apply_immediately

  tags = module.this.tags

  dynamic "cluster_mode" {
    for_each = var.cluster_mode_enabled ? ["true"] : []
    content {
      replicas_per_node_group = var.cluster_mode_replicas_per_node_group
      num_node_groups         = var.cluster_mode_num_node_groups
    }
  }
}

#
# CloudWatch Resources
#
resource "aws_cloudwatch_metric_alarm" "cache_cpu" {
  count               = module.this.enabled && var.cloudwatch_metric_alarms_enabled ? local.member_clusters_count : 0
  alarm_name          = "${element(local.elasticache_member_clusters, count.index)}-cpu-utilization"
  alarm_description   = "Redis cluster CPU utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = "300"
  statistic           = "Average"

  threshold = var.alarm_cpu_threshold_percent

  dimensions = {
    CacheClusterId = element(local.elasticache_member_clusters, count.index)
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions
  depends_on    = [aws_elasticache_replication_group.default]
}

resource "aws_cloudwatch_metric_alarm" "cache_memory" {
  count               = module.this.enabled && var.cloudwatch_metric_alarms_enabled ? local.member_clusters_count : 0
  alarm_name          = "${element(local.elasticache_member_clusters, count.index)}-freeable-memory"
  alarm_description   = "Redis cluster freeable memory"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/ElastiCache"
  period              = "60"
  statistic           = "Average"

  threshold = var.alarm_memory_threshold_bytes

  dimensions = {
    CacheClusterId = element(local.elasticache_member_clusters, count.index)
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions
  depends_on    = [aws_elasticache_replication_group.default]
}

module "dns" {
  source  = "cloudposse/route53-cluster-hostname/aws"
  version = "0.12.0"

  enabled  = module.this.enabled && var.zone_id != "" ? true : false
  dns_name = var.dns_subdomain != "" ? var.dns_subdomain : module.this.id
  ttl      = 60
  zone_id  = var.zone_id
  records  = var.cluster_mode_enabled ? [join("", aws_elasticache_replication_group.default.*.configuration_endpoint_address)] : [join("", aws_elasticache_replication_group.default.*.primary_endpoint_address)]

  context = module.this.context
}
