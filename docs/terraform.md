
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| alarm_actions | Alarm action list | list | `<list>` | no |
| alarm_cpu_threshold_percent | CPU threshold alarm level | string | `75` | no |
| alarm_memory_threshold_bytes | Ram threshold alarm level | string | `10000000` | no |
| apply_immediately | Apply changes immediately | string | `true` | no |
| at_rest_encryption_enabled | Enable encryption at rest | string | `false` | no |
| attributes | Additional attributes (_e.g._ "1") | list | `<list>` | no |
| automatic_failover | Automatic failover (Not available for T1/T2 instances) | string | `false` | no |
| availability_zones | Availability zone ids | list | `<list>` | no |
| cluster_size | Count of nodes in cluster | string | `1` | no |
| delimiter | Delimiter between `name`, `namespace`, `stage` and `attributes` | string | `-` | no |
| enabled | Set to false to prevent the module from creating any resources | string | `true` | no |
| engine_version | Redis engine version | string | `4.0.10` | no |
| family | Redis family | string | `redis4.0` | no |
| instance_type | Elastic cache instance type | string | `cache.t2.micro` | no |
| maintenance_window | Maintenance window | string | `wed:03:00-wed:04:00` | no |
| name | Name | string | `redis` | no |
| namespace | Namespace | string | `global` | no |
| notification_topic_arn | Notification topic arn | string | `10000000` | no |
| port | Redis port | string | `6379` | no |
| security_groups | AWS security group ids | list | `<list>` | no |
| stage | Stage | string | `default` | no |
| subnets | AWS subnet ids | list | `<list>` | no |
| tags | Additional tags (_e.g._ map("BusinessUnit","ABC") | map | `<map>` | no |
| transit_encryption_enabled | Enable TLS | string | `false` | no |
| vpc_id | AWS VPC id | string | `REQUIRED` | no |
| zone_id | Route53 DNS Zone id | string | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| host | Redis host |
| id | Redis cluster id |
| port | Redis port |
| security_group_id | Security group id |

