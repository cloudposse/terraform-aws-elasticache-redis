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
  type = object({
    data_storage_max    = number
    data_storage_unit   = string
    ecpu_per_second_max = number
  })
  description = "Serverless cache usage limits"
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