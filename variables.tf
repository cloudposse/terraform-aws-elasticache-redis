variable "namespace" {
  default = "global"
}

variable "enabled" {
  description = "Set to false to prevent the module from creating any resources"
  default     = "true"
}

variable "stage" {
  default = "default"
}

variable "name" {
  default = "redis"
}

variable "dns_name" {
  default = "redis"
}

variable "security_groups" {
  type = "list"
}

variable "vpc_id" {
  default = ""
}

variable "subnets" {
  type    = "list"
  default = []
}

variable "maintenance_window" {
  default = "wed:03:00-wed:04:00"
}

variable "cluster_size" {
  default = "1"
}

variable "port" {
  default = "6379"
}

variable "instance_type" {
  default = "cache.t2.micro"
}

# format HH24:mm-HH24:mm
variable "snapshot_window" {
  default = ""
}

variable "snapshot_name" {
  default = ""
}

variable "snapshot_retention_limit" {
  default = 0
}

variable "snapshot_arns" {
  type    = "list"
  default = []
}

variable "family" {
  default = "redis5.0"
}

variable "engine_version" {
  default = "5.0.0"
}

variable "notification_topic_arn" {
  default = ""
}

variable "alarm_cpu_threshold_percent" {
  default = "75"
}

variable "alarm_memory_threshold_bytes" {
  # 10MB
  default = "10000000"
}

variable "alarm_actions" {
  type    = "list"
  default = []
}

variable "apply_immediately" {
  default = "true"
}

variable "automatic_failover" {
  default = "false"
}

variable "availability_zones" {
  type = "list"
}

variable "zone_id" {}

variable "delimiter" {
  type    = "string"
  default = "-"
}

variable "attributes" {
  type    = "list"
  default = []
}

variable "tags" {
  type    = "map"
  default = {}
}
