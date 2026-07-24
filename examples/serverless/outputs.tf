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

output "serverless_arn" {
  value       = module.redis.arn
  description = "Elasticache Replication Group ARN"
}

output "cluster_security_group_id" {
  value       = module.redis.security_group_id
  description = "Cluster Security Group ID"
}

output "serverless_endpoint" {
  value       = module.redis.endpoint
  description = "Redis primary endpoint"
}

output "cluster_reader_endpoint_address" {
  value       = module.redis.reader_endpoint_address
  description = "Redis non-cluster reader endpoint"
}

output "serverless_host" {
  value       = module.redis.host
  description = "Redis hostname"
}

output "serverless_enabled" {
  value       = module.redis.serverless_enabled
  description = "Indicates if serverless mode is enabled"
}
