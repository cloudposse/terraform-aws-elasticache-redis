# security_group_inputs Version: 1
##


variable "create_security_group" {
  type        = bool
  default     = true
  description = "Set `true` to create and configure a new security group. If false, `associated_security_group_ids` must be provided."
}

locals {
  create_security_group = local.enabled && (var.use_existing_security_groups == null ? var.create_security_group : !var.use_existing_security_groups)
}

variable "associated_security_group_ids" {
  type        = list(string)
  default     = []
  description = <<-EOT
    A list of IDs of Security Groups to associate the created resource with, in addition to the created security group.
    These security groups will not be modified and, if `create_security_group` is `false`, must provide all the required access.
    EOT
}

locals {
  associated_security_group_ids = concat(var.existing_security_groups, var.associated_security_group_ids)
}

variable "allowed_security_group_ids" {
  type        = list(string)
  default     = []
  description = <<-EOT
    A list of IDs of Security Groups to allow access to the security group created by this module.
  EOT
}

locals {
  allowed_security_group_ids = concat(var.allowed_security_groups, var.allowed_security_group_ids)
}


variable "security_group_name" {
  type        = list(string)
  default     = []
  description = <<-EOT
    The name to assign to the created security group. Must be unique within the VPC.
    If not provided, will be derived from the `null-label.context` passed in.
    If `create_before_destroy` is true, will be used as a name prefix.
    EOT
}

variable "security_group_description" {
  type        = string
  default     = "Security group for Elasticache Redis"
  description = <<-EOT
    The description to assign to the created Security Group.
    Warning: Changing the description causes the security group to be replaced.
    Set this to `null` to maintain parity with releases <= `0.34.0`.
    EOT
}

locals {
  security_group_description = var.security_group_description == null ? "Managed by Terraform" : var.security_group_description
}

variable "security_group_create_before_destroy" {
  type        = bool
  default     = true
  description = <<-EOT
    Set `true` to enable Terraform `create_before_destroy` behavior on the created security group.
    We only recommend setting this `false` if you are upgrading this module and need to keep
    the existing security group from being replaced.
    Note that changing this value will always cause the security group to be replaced.
    EOT
}

variable "security_group_create_timeout" {
  type        = string
  default     = "10m"
  description = "How long to wait for the security group to be created."
}

variable "security_group_delete_timeout" {
  type        = string
  default     = "15m"
  description = <<-EOT
    How long to retry on `DependencyViolation` errors during security group deletion.
    EOT
}


variable "allow_all_egress" {
  type        = bool
  default     = null
  description = <<-EOT
    If `true`, the created security group will allow egress on all ports and protocols to all IP address.
    If this is false and no egress rules are otherwise specified, then no egress will be allowed.
    Defaults to `true` unless the deprecated `egress_cidr_blocks` is provided and is not `["0.0.0.0/0"]`, in which case defaults to `false`.
    EOT
}

variable "additional_security_group_rules" {
  type        = list(any)
  default     = []
  description = <<-EOT
    A list of Security Group rule objects to add to the created security group, in addition to the ones
    this module normally creates. (To suppress the module's rules, set `create_security_group` to false
    and supply your own security group via `associated_security_group_ids`.)
    The keys and values of the objects are fully compatible with the `aws_security_group_rule` resource, except
    for `security_group_id` which will be ignored, and the optional "key" which, if provided, must be unique and known at "plan" time.
    To get more info see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule .
    EOT
}
