variable "enabled" {
  type        = bool
  description = "Set to false to prevent the module from creating any resources"
  default     = true
}

variable "namespace" {
  type        = string
  description = "Namespace (e.g. `eg` or `cp`)"
  default     = ""
}

variable "stage" {
  type        = string
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
  default     = ""
}

variable "name" {
  type        = string
  description = "Name of the application"
}

variable "security_groups" {
  type        = list(string)
  default     = []
  description = "Security Group IDs"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "subnets" {
  type        = list(string)
  description = "Subnet IDs"
  default     = []
}

variable "elasticache_subnet_group_name" {
  type        = string
  description = "Subnet group name for the ElastiCache instance"
  default     = ""
}

variable "maintenance_window" {
  type        = string
  default     = "wed:03:00-wed:04:00"
  description = "Maintenance window"
}

variable "cluster_size" {
  type        = number
  default     = 1
  description = "Count of nodes in cluster"
}

variable "port" {
  type        = number
  default     = 6379
  description = "Redis port"
}

variable "instance_type" {
  type        = string
  default     = "cache.t2.micro"
  description = "Elastic cache instance type"
}

variable "family" {
  type        = string
  default     = "redis4.0"
  description = "Redis family"
}

variable "parameter" {
  type = list(object({
    name  = string
    value = string
  }))
  default     = []
  description = "A list of Redis parameters to apply. Note that parameters may differ from one Redis family to another"
}

variable "engine_version" {
  type        = string
  default     = "4.0.10"
  description = "Redis engine version"
}

variable "at_rest_encryption_enabled" {
  type        = bool
  default     = false
  description = "Enable encryption at rest"
}

variable "transit_encryption_enabled" {
  type        = bool
  default     = true
  description = "Enable TLS"
}

variable "notification_topic_arn" {
  type        = string
  default     = ""
  description = "Notification topic arn"
}

variable "alarm_cpu_threshold_percent" {
  type        = number
  default     = 75
  description = "CPU threshold alarm level"
}

variable "alarm_memory_threshold_bytes" {
  # 10MB
  type        = number
  default     = 10000000
  description = "Ram threshold alarm level"
}

variable "alarm_actions" {
  type        = list(string)
  description = "Alarm action list"
  default     = []
}

variable "ok_actions" {
  type        = list(string)
  description = "The list of actions to execute when this alarm transitions into an OK state from any other state. Each action is specified as an Amazon Resource Number (ARN)"
  default     = []
}

variable "apply_immediately" {
  type        = bool
  default     = true
  description = "Apply changes immediately"
}

variable "automatic_failover" {
  type        = bool
  default     = false
  description = "Automatic failover (Not available for T1/T2 instances)"
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability zone IDs"
  default     = []
}

variable "zone_id" {
  type        = string
  default     = ""
  description = "Route53 DNS Zone ID"
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter between `name`, `namespace`, `stage` and `attributes`"
}

variable "attributes" {
  type        = list(string)
  description = "Additional attributes (_e.g._ \"1\")"
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Additional tags (_e.g._ map(\"BusinessUnit\",\"ABC\")"
  default     = {}
}

variable "auth_token" {
  type        = string
  description = "Auth token for password protecting redis, `transit_encryption_enabled` must be set to `true`. Password must be longer than 16 chars"
  default     = ""
}

variable "replication_group_id" {
  type        = string
  description = "Replication group ID with the following constraints: \nA name must contain from 1 to 20 alphanumeric characters or hyphens. \n The first character must be a letter. \n A name cannot end with a hyphen or contain two consecutive hyphens."
  default     = ""
}
