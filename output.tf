output "id" {
  value = "${aws_elasticache_replication_group.default.id}"
}

output "security_group_id" {
  value = "${aws_security_group.default.id}"
}

output "host" {
  value = "${module.dns.hostname}"
}

