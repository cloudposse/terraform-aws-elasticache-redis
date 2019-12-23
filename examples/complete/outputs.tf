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

output "cluster_security_group_id" {
  value       = module.redis.security_group_id
  description = "Cluster Security Group ID"
}

output "cluster_endpoint" {
  value       = module.redis.endpoint
  description = "Redis primary endpoint"
}

output "cluster_host" {
  value       = module.redis.host
  description = "Redis hostname"
}
