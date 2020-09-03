<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.0 |
| aws | >= 2.0 |
| null | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alarm\_actions | Alarm action list | `list(string)` | `[]` | no |
| alarm\_cpu\_threshold\_percent | CPU threshold alarm level | `number` | `75` | no |
| alarm\_memory\_threshold\_bytes | Ram threshold alarm level | `number` | `10000000` | no |
| allowed\_cidr\_blocks | List of CIDR blocks that are allowed ingress to the cluster's Security Group created in the module | `list(string)` | `[]` | no |
| allowed\_security\_groups | List of Security Group IDs that are allowed ingress to the cluster's Security Group created in the module | `list(string)` | `[]` | no |
| apply\_immediately | Apply changes immediately | `bool` | `true` | no |
| at\_rest\_encryption\_enabled | Enable encryption at rest | `bool` | `false` | no |
| attributes | Additional attributes (\_e.g.\_ "1") | `list(string)` | `[]` | no |
| auth\_token | Auth token for password protecting redis, `transit_encryption_enabled` must be set to `true`. Password must be longer than 16 chars | `string` | `null` | no |
| automatic\_failover\_enabled | Automatic failover (Not available for T1/T2 instances) | `bool` | `false` | no |
| availability\_zones | Availability zone IDs | `list(string)` | `[]` | no |
| cluster\_mode\_enabled | Flag to enable/disable creation of a native redis cluster. `automatic_failover_enabled` must be set to `true`. Only 1 `cluster_mode` block is allowed | `bool` | `false` | no |
| cluster\_mode\_num\_node\_groups | Number of node groups (shards) for this Redis replication group. Changing this number will trigger an online resizing operation before other settings modifications | `number` | `0` | no |
| cluster\_mode\_replicas\_per\_node\_group | Number of replica nodes in each node group. Valid values are 0 to 5. Changing this number will force a new resource | `number` | `0` | no |
| cluster\_size | Number of nodes in cluster. \*Ignored when `cluster_mode_enabled` == `true`\* | `number` | `1` | no |
| delimiter | Delimiter between `name`, `namespace`, `stage` and `attributes` | `string` | `"-"` | no |
| dns\_subdomain | The subdomain to use for the CNAME record. If not provided then the CNAME record will use var.name. | `string` | `""` | no |
| elasticache\_subnet\_group\_name | Subnet group name for the ElastiCache instance | `string` | `""` | no |
| enabled | Set to false to prevent the module from creating any resources | `bool` | `true` | no |
| engine\_version | Redis engine version | `string` | `"4.0.10"` | no |
| existing\_security\_groups | List of existing Security Group IDs to place the cluster into. Set `use_existing_security_groups` to `true` to enable using `existing_security_groups` as Security Groups for the cluster | `list(string)` | `[]` | no |
| family | Redis family | `string` | `"redis4.0"` | no |
| instance\_type | Elastic cache instance type | `string` | `"cache.t2.micro"` | no |
| kms\_key\_id | The ARN of the key that you wish to use if encrypting at rest. If not supplied, uses service managed encryption. `at_rest_encryption_enabled` must be set to `true` | `string` | `null` | no |
| maintenance\_window | Maintenance window | `string` | `"wed:03:00-wed:04:00"` | no |
| name | Name of the application | `string` | n/a | yes |
| namespace | Namespace (e.g. `eg` or `cp`) | `string` | `""` | no |
| notification\_topic\_arn | Notification topic arn | `string` | `""` | no |
| ok\_actions | The list of actions to execute when this alarm transitions into an OK state from any other state. Each action is specified as an Amazon Resource Number (ARN) | `list(string)` | `[]` | no |
| parameter | A list of Redis parameters to apply. Note that parameters may differ from one Redis family to another | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | `[]` | no |
| port | Redis port | `number` | `6379` | no |
| replication\_group\_id | Replication group ID with the following constraints: <br>A name must contain from 1 to 20 alphanumeric characters or hyphens. <br> The first character must be a letter. <br> A name cannot end with a hyphen or contain two consecutive hyphens. | `string` | `""` | no |
| snapshot\_retention\_limit | The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them. | `number` | `0` | no |
| snapshot\_window | The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster. | `string` | `"06:30-07:30"` | no |
| stage | Stage (e.g. `prod`, `dev`, `staging`) | `string` | `""` | no |
| subnets | Subnet IDs | `list(string)` | `[]` | no |
| tags | Additional tags (\_e.g.\_ map("BusinessUnit","ABC") | `map(string)` | `{}` | no |
| transit\_encryption\_enabled | Enable TLS | `bool` | `true` | no |
| use\_existing\_security\_groups | Flag to enable/disable creation of Security Group in the module. Set to `true` to disable Security Group creation and provide a list of existing security Group IDs in `existing_security_groups` to place the cluster into | `bool` | `false` | no |
| vpc\_id | VPC ID | `string` | n/a | yes |
| zone\_id | Route53 DNS Zone ID | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| endpoint | Redis primary endpoint |
| host | Redis hostname |
| id | Redis cluster ID |
| port | Redis port |
| security\_group\_id | Security group ID |

<!-- markdownlint-restore -->
