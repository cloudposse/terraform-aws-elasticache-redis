#
# Security Group Resources
#
locals {
  enabled = module.this.enabled

  legacy_egress_rule = local.use_legacy_egress ? {
    key         = "legacy-egress"
    type        = "egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.egress_cidr_blocks
    description = "Allow outbound traffic to existing CIDR blocks"
  } : null

  legacy_cidr_ingress_rule = length(var.allowed_cidr_blocks) == 0 ? null : {
    key         = "legacy-cidr-ingress"
    type        = "ingress"
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
    description = "Allow inbound traffic from CIDR blocks"
  }

  sg_rules = {
    legacy = merge(local.legacy_egress_rule, local.legacy_cidr_ingress_rule),
    extra  = var.additional_security_group_rules
  }
}

module "aws_security_group" {
  source  = "cloudposse/security-group/aws"
  version = "1.0.1"

  enabled = local.create_security_group

  allow_all_egress    = local.allow_all_egress
  security_group_name = var.security_group_name
  rules_map           = local.sg_rules
  rule_matrix = [{
    key                       = "in"
    source_security_group_ids = local.allowed_security_group_ids
    cidr_blocks               = var.allowed_cidr_blocks
    rules = [{
      key         = "in"
      type        = "ingress"
      from_port   = var.port
      to_port     = var.port
      protocol    = "tcp"
      description = "Selectively allow inbound traffic"
    }]
  }]

  vpc_id = var.vpc_id

  security_group_description = local.security_group_description

  create_before_destroy = var.security_group_create_before_destroy

  security_group_create_timeout = var.security_group_create_timeout
  security_group_delete_timeout = var.security_group_delete_timeout

  context = module.this.context
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
  count       = module.this.enabled && var.elasticache_subnet_group_name == "" && length(var.subnets) > 0 ? 1 : 0
  name        = module.this.id
  description = "Elasticache subnet group for ${module.this.id}"
  subnet_ids  = var.subnets
  tags        = module.this.tags
}

resource "aws_elasticache_parameter_group" "default" {
  count       = module.this.enabled ? 1 : 0
  name        = module.this.id
  description = var.parameter_group_description != null ? var.parameter_group_description : "Elasticache parameter group for ${module.this.id}"
  family      = var.family

  dynamic "parameter" {
    for_each = var.cluster_mode_enabled ? concat([{ name = "cluster-enabled", value = "yes" }], var.parameter) : var.parameter
    content {
      name  = parameter.value.name
      value = tostring(parameter.value.value)
    }
  }

  tags = module.this.tags

  # Ignore changes to the description since it will try to recreate the resource
  lifecycle {
    ignore_changes = [
      description,
    ]
  }
}

resource "aws_elasticache_replication_group" "default" {
  count = module.this.enabled ? 1 : 0

  auth_token                 = var.transit_encryption_enabled ? var.auth_token : null
  replication_group_id       = var.replication_group_id == "" ? module.this.id : var.replication_group_id
  description                = coalesce(var.description, module.this.id)
  node_type                  = var.instance_type
  num_cache_clusters         = var.cluster_mode_enabled ? null : var.cluster_size
  port                       = var.port
  parameter_group_name       = join("", aws_elasticache_parameter_group.default.*.name)
  availability_zones         = length(var.availability_zones) == 0 ? null : [for n in range(0, var.cluster_size) : element(var.availability_zones, n)]
  automatic_failover_enabled = var.cluster_mode_enabled ? true : var.automatic_failover_enabled
  multi_az_enabled           = var.multi_az_enabled
  subnet_group_name          = local.elasticache_subnet_group_name
  # It would be nice to remove null or duplicate security group IDs, if there are any, using `compact`,
  # but that causes problems, and having duplicates does not seem to cause problems.
  # See https://github.com/hashicorp/terraform/issues/29799
  security_group_ids         = local.create_security_group ? concat(local.associated_security_group_ids, [module.aws_security_group.id]) : local.associated_security_group_ids
  maintenance_window         = var.maintenance_window
  notification_topic_arn     = var.notification_topic_arn
  engine_version             = var.engine_version
  at_rest_encryption_enabled = var.at_rest_encryption_enabled
  transit_encryption_enabled = var.transit_encryption_enabled || var.auth_token != null
  kms_key_id                 = var.at_rest_encryption_enabled ? var.kms_key_id : null
  snapshot_name              = var.snapshot_name
  snapshot_arns              = var.snapshot_arns
  snapshot_window            = var.snapshot_window
  snapshot_retention_limit   = var.snapshot_retention_limit
  final_snapshot_identifier  = var.final_snapshot_identifier
  apply_immediately          = var.apply_immediately
  data_tiering_enabled       = var.data_tiering_enabled
  auto_minor_version_upgrade = var.auto_minor_version_upgrade

  dynamic "log_delivery_configuration" {
    for_each = var.log_delivery_configuration

    content {
      destination      = lookup(log_delivery_configuration.value, "destination", null)
      destination_type = lookup(log_delivery_configuration.value, "destination_type", null)
      log_format       = lookup(log_delivery_configuration.value, "log_format", null)
      log_type         = lookup(log_delivery_configuration.value, "log_type", null)
    }
  }

  tags = module.this.tags

  num_node_groups         = var.cluster_mode_enabled ? var.cluster_mode_num_node_groups : null
  replicas_per_node_group = var.cluster_mode_enabled ? var.cluster_mode_replicas_per_node_group : null
  user_group_ids          = var.user_group_ids
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

  tags = module.this.tags
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

  tags = module.this.tags
}

module "dns" {
  source  = "cloudposse/route53-cluster-hostname/aws"
  version = "0.12.2"

  enabled  = module.this.enabled && length(var.zone_id) > 0 ? true : false
  dns_name = var.dns_subdomain != "" ? var.dns_subdomain : module.this.id
  ttl      = 60
  zone_id  = try(var.zone_id[0], tostring(var.zone_id), "")
  records  = var.cluster_mode_enabled ? [join("", aws_elasticache_replication_group.default.*.configuration_endpoint_address)] : [join("", aws_elasticache_replication_group.default.*.primary_endpoint_address)]

  context = module.this.context
}
