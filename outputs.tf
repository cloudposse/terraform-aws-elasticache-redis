output "id" {
  value       = join("", aws_elasticache_replication_group.default.*.id)
  description = "Redis cluster ID"
}

output "security_group_id" {
  value       = join("", aws_security_group.default.*.id)
  description = "Security group ID"
}

output "port" {
  value       = var.port
  description = "Redis port"
}

output "host" {
  value = coalesce(
    module.dns.hostname,
    join(
      "",
      aws_elasticache_replication_group.default.*.primary_endpoint_address
    )
  )
  description = "Redis host"
}
