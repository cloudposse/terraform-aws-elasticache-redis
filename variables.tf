variable "application" {
  type        = string
  description = "This value is part of the AWS cloud asset tagging strategy to be able to group items by application."
}

variable "environment" {
  type        = string
  description = "This value is part of the AWS cloud asset tagging strategy to be able to group items by environment."
}

variable "repo" {
  type        = string
  description = "This value is part of the AWS cloud asset tagging strategy to be able to group items by repo."
}

variable "repo_path" {
  type        = string
  description = "This value is part of the AWS cloud asset tagging strategy to be able to group items by repo and subgroup them by the repos path."
}

variable "owner" {
  type        = string
  description = "This value is part of the AWS cloud asset tagging strategy to be able to group items by owner."
}

variable "additional_tags" {
  type        = map(string)
  description = "Additional tags to add to your resources in addition to default."
  default     = {}
}

variable "aws_profile" {
  type        = string
  description = "AWS profile for provider"
  default     = "default"
}

variable "aws_region" {
  type        = string
  description = "AWS region for provider."
  default     = "us-east-1"
}

#### redis module variables ####

variable "subscription_pagerduty_endpoint" {
  type        = string
  description = "Pagerduty endpoint for SNS topic subscription (alarms)."
}

variable "cpu_utilization_high_evaluation_periods" {
  type        = number
  description = "Number of periods to evaluate for the alarm."
  default     = 1
}

variable "memory_utilization_high_evaluation_periods" {
  type        = number
  description = "Number of periods to evaluate for the alarm."
  default     = 1
}

variable "cpu_utilization_high_threshold" {
  type        = number
  description = "The maximum percentage of CPU utilization average."
  default     = 80
}

variable "memory_utilization_high_threshold" {
  type        = number
  description = "The maximum percentage of memory utilization average."
  default     = 80
}

variable "cpu_utilization_high_period" {
  type        = number
  description = "Duration in seconds to evaluate for the alarm."
  default     = 300
}

variable "memory_utilization_high_period" {
  type        = number
  description = "Duration in seconds to evaluate for the alarm."
  default     = 300
}


##########existing vars################
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

variable "use_existing_security_groups" {
  type        = bool
  description = "Flag to enable/disable creation of Security Group in the module. Set to `true` to disable Security Group creation and provide a list of existing security Group IDs in `existing_security_groups` to place the cluster into"
  default     = false
}

variable "existing_security_groups" {
  type        = list(string)
  default     = []
  description = "List of existing Security Group IDs to place the cluster into. Set `use_existing_security_groups` to `true` to enable using `existing_security_groups` as Security Groups for the cluster"
}

variable "allowed_security_groups" {
  type        = list(string)
  default     = []
  description = "List of Security Group IDs that are allowed ingress to the cluster's Security Group created in the module"
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "List of CIDR blocks that are allowed ingress to the cluster's Security Group created in the module"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "subnet_ids" {
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
  description = "Number of nodes in cluster. *Ignored when `cluster_mode_enabled` == `true`*"
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
  default     = true
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

variable "automatic_failover_enabled" {
  type        = bool
  default     = true
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

variable "redis_fqdn" {
  type        = string
  default     = ""
  description = "The subdomain to use for the CNAME record. If not provided then the CNAME record will use var.name."
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
  default     = null
}

variable "snapshot_window" {
  type        = string
  description = "The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster."
  default     = "06:30-07:30"
}

variable "snapshot_retention_limit" {
  type        = number
  description = "The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them."
  default     = 0
}

variable "cluster_mode_enabled" {
  type        = bool
  description = "Flag to enable/disable creation of a native redis cluster. `automatic_failover_enabled` must be set to `true`. Only 1 `cluster_mode` block is allowed"
  default     = false
}

variable "cluster_mode_replicas_per_node_group" {
  type        = number
  description = "Number of replica nodes in each node group. Valid values are 0 to 5. Changing this number will force a new resource"
  default     = 0
}

variable "cluster_mode_num_node_groups" {
  type        = number
  description = "Number of node groups (shards) for this Redis replication group. Changing this number will trigger an online resizing operation before other settings modifications"
  default     = 0
}
