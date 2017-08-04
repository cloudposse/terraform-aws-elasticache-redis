variable "namespace" {
  default = "global"
}

variable "stage" {
  default = "default"
}

variable "name" {
  default = "redis"
}

variable "security_groups" {
  type = "list"
}

variable "vpc_id" {
  default = ""
}

variable "max_item_size" {
  default = "10485760"
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

variable "instance_type" {
  default = "cache.t2.micro"
}

variable "engine_version" {
  default = "3.2"
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

variable "availability_zones" {
  type = "list"
}

variable "zone_id" {}
