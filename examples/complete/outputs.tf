output "public_subnet_cidrs" {
  value       = module.subnets.public_subnet_cidrs
  description = "Public subnet CIDRs"
}

output "private_subnet_cidrs" {
  value       = module.subnets.private_subnet_cidrs
  description = "Private subnet CIDRs"
}

output "vpc_cidr" {
  value       = module.vpc.vpc_cidr_block
  description = "VPC CIDR"
}

output "cluster_id" {
  value       = module.redis.id
  description = "Redis cluster ID"
}

output "cluster_arn" {
  value       = module.redis.arn
  description = "Elasticache Replication Group ARN"
}

output "cluster_enabled" {
  value       = module.redis.cluster_enabled
  description = "Indicates if cluster mode is enabled"
}

output "engine_version_actual" {
  value       = module.redis.engine_version_actual
  description = "The running version of the cache engine"
}

output "cluster_security_group_id" {
  value       = module.redis.security_group_id
  description = "Cluster Security Group ID"
}

output "cluster_endpoint" {
  value       = module.redis.endpoint
  description = "Redis primary endpoint"
}

output "cluster_reader_endpoint_address" {
  value       = module.redis.reader_endpoint_address
  description = "Redis non-cluster reader endpoint"
}

output "cluster_host" {
  value       = module.redis.host
  description = "Redis hostname"
}
