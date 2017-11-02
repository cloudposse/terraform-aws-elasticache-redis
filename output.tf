output "id" {
  value = "${join("", aws_elasticache_replication_group.default.*.id)}"
}

output "security_group_id" {
  value = "${join("", aws_security_group.default.*.id)}"
}

output "port" {
  value = "${var.port}"
}

output "host" {
  value = "${module.dns.hostname}"
}
