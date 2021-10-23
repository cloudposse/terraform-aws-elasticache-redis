output "id" {
  value       = join("", aws_elasticache_replication_group.default.*.id)
  description = "Redis cluster ID"
}

output "security_group_id" {
  value       = module.aws_security_group.id
  description = "The ID of the created security group"
}

output "security_group_name" {
  value       = module.aws_security_group.name
  description = "The name of the created security group"
}

output "port" {
  value       = var.port
  description = "Redis port"
}

output "endpoint" {
  value       = var.cluster_mode_enabled ? join("", aws_elasticache_replication_group.default.*.configuration_endpoint_address) : join("", aws_elasticache_replication_group.default.*.primary_endpoint_address)
  description = "Redis primary endpoint"
}

output "member_clusters" {
  value       = aws_elasticache_replication_group.default.*.member_clusters
  description = "Redis cluster members"
}

output "host" {
  value       = module.dns.hostname
  description = "Redis hostname"
}
