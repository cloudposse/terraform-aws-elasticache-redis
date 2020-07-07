output "id" {
  value       = join("", aws_elasticache_replication_group.default.*.id)
  description = "Redis cluster ID"
}

output "security_group_id" {
  value       = module.redis_security_group.security_group_id
  description = "Security group ID"
}

output "port" {
  value       = var.port
  description = "Redis port"
}

output "endpoint" {
  value       = var.cluster_mode_enabled ? aws_elasticache_replication_group.default.*.configuration_endpoint_address : aws_elasticache_replication_group.default.*.primary_endpoint_address
  description = "Redis primary endpoint"
}

output "fqdn" {
  value       = aws_route53_record.redis.fqdn
  description = "Redis CNAME fqdn"
}
