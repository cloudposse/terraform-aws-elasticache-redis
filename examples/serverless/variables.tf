variable "region" {
  type        = string
  description = "AWS region"
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability zone IDs"
}

variable "serverless_enabled" {
  type        = bool
  description = "Enable serverless"
}

variable "serverless_major_engine_version" {
  type        = string
  description = "Serverless major engine version"
}

variable "serverless_cache_usage_limits" {
  type        = map(any)
  description = "Serverless cache usage limits"
  default     = {}
}

variable "at_rest_encryption_enabled" {
  type        = bool
  description = "Enable encryption at rest"
}

variable "sg_name" {
  type        = string
  default     = ""
  description = "Name to give to created security group"
}

variable "serverless_snapshot_arns_to_restore" {
  type        = list(string)
  default     = []
  description = "The list of ARN(s) of the snapshot that the new serverless cache will be created from. Available for Redis only."
}
