# Define composite variables for resources
module "label" {
  source    = "git::https://github.com/cloudposse/tf_label.git"
  namespace = "${var.namespace}"
  name      = "${var.name}"
  stage     = "${var.stage}"
}

#
# Security Group Resources
#
resource "aws_security_group" "default" {
  vpc_id = "${var.vpc_id}"
  name   = "${module.label.id}"

  ingress {
    from_port       = "6380"                     # Redis
    to_port         = "6380"
    protocol        = "tcp"
    security_groups = ["${var.security_groups}"]
  }

  ingress {
    from_port       = "6379"                     # Memcache
    to_port         = "6379"
    protocol        = "tcp"
    security_groups = ["${var.security_groups}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name      = "${module.label.id}"
    Namespace = "${var.namespace}"
    Stage     = "${var.stage}"
  }
}

resource "aws_elasticache_subnet_group" "default" {
  name       = "${module.label.id}"
  subnet_ids = ["${var.subnets}"]
}

resource "aws_elasticache_parameter_group" "default" {
  name   = "${module.label.id}"
  family = "redis3.2"
}

resource "aws_elasticache_replication_group" "default" {
  replication_group_id          = "${module.label.id}"
  replication_group_description = "${module.label.id}"
  node_type                     = "${var.instance_type}"
  number_cache_clusters         = "${var.cluster_size}"
  port                          = 6379
  parameter_group_name          = "${aws_elasticache_parameter_group.default.name}"
  availability_zones            = ["${slice(var.availability_zones, 0, var.cluster_size)}"]
  automatic_failover_enabled    = true
  subnet_group_name             = "${aws_elasticache_subnet_group.default.name}"
  security_group_ids            = ["${aws_security_group.default.id}"]
  maintenance_window            = "${var.maintenance_window}"
  notification_topic_arn        = "${var.notification_topic_arn}"
}

#
# CloudWatch Resources
#
resource "aws_cloudwatch_metric_alarm" "cache_cpu" {
  alarm_name          = "${module.label.id}-cpu-utilization"
  alarm_description   = "Redis cluster CPU utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = "300"
  statistic           = "Average"

  threshold = "${var.alarm_cpu_threshold_percent}"

  dimensions {
    CacheClusterId = "${module.label.id}"
  }

  alarm_actions = ["${var.alarm_actions}"]
  depends_on    = ["aws_elasticache_replication_group.default"]
}

resource "aws_cloudwatch_metric_alarm" "cache_memory" {
  alarm_name          = "${module.label.id}-freeable-memory"
  alarm_description   = "Redis cluster freeable memory"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/ElastiCache"
  period              = "60"
  statistic           = "Average"

  threshold = "${var.alarm_memory_threshold_bytes}"

  dimensions {
    CacheClusterId = "${module.label.id}"
  }

  alarm_actions = ["${var.alarm_actions}"]
  depends_on    = ["aws_elasticache_replication_group.default"]
}

/*
module "dns" {
  source    = "../hostname"
  namespace = "${var.namespace}"
  name      = "${var.name}"
  stage     = "${var.stage}"
  ttl       = 60
  zone_id   = "${var.zone_id}"
  records   = ["${aws_elasticache_replication_group.default.cluster_address}"]
}

module "dns_config" {
  source    = "../hostname"
  namespace = "${var.namespace}"
  name      = "config.${var.name}"
  stage     = "${var.stage}"
  ttl       = 60
  zone_id   = "${var.zone_id}"
  records   = ["${aws_elasticache_replication_group.default.configuration_endpoint}"]
}
*/

