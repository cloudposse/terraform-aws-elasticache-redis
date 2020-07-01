# terraform-aws-elasticcache-redis

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| additional\_tags | Additional tags to add to your resources in addition to default. | `map(string)` | `{}` | no |
| alarm\_actions | Alarm action list | `list(string)` | `[]` | no |
| allowed\_cidr\_blocks | List of CIDR blocks that are allowed ingress to the cluster's Security Group created in the module | `list(string)` | `[]` | no |
| allowed\_security\_groups | List of Security Group IDs that are allowed ingress to the cluster's Security Group created in the module | `list(string)` | `[]` | no |
| application | This value is part of the AWS cloud asset tagging strategy to be able to group items by application. | `string` | n/a | yes |
| apply\_immediately | Apply changes immediately | `bool` | `true` | no |
| at\_rest\_encryption\_enabled | Enable encryption at rest | `bool` | `true` | no |
| attributes | Additional attributes (\_e.g._ "1") | `list(string)` | `[]` | no |
| auth\_token | Auth token for password protecting redis, `transit_encryption_enabled` must be set to `true`. Password must be longer than 16 chars | `string` | n/a | yes |
| automatic\_failover\_enabled | Automatic failover (Not available for T1/T2 instances) | `bool` | `true` | no |
| availability\_zones | Availability zone IDs | `list(string)` | `[]` | no |
| aws\_profile | AWS profile for provider | `string` | `"default"` | no |
| aws\_region | AWS region for provider. | `string` | `"us-east-1"` | no |
| cluster\_mode\_enabled | Flag to enable/disable creation of a native redis cluster. `automatic_failover_enabled` must be set to `true`. Only 1 `cluster_mode` block is allowed | `bool` | `true` | no |
| cluster\_mode\_num\_node\_groups | Number of node groups (shards) for this Redis replication group. Changing this number will trigger an online resizing operation before other settings modifications | `number` | `0` | no |
| cluster\_mode\_replicas\_per\_node\_group | Number of replica nodes in each node group. Valid values are 0 to 5. Changing this number will force a new resource | `number` | `0` | no |
| cluster\_size | Number of nodes in cluster. *Ignored when `cluster_mode_enabled` == `true`\* | `number` | `2` | no |
| cpu\_utilization\_high\_evaluation\_periods | Number of periods to evaluate for the alarm. | `number` | `1` | no |
| cpu\_utilization\_high\_period | Duration in seconds to evaluate for the alarm. | `number` | `300` | no |
| cpu\_utilization\_high\_threshold | The maximum percentage of CPU utilization average. | `number` | `80` | no |
| delimiter | Delimiter between `name`, `namespace`, `stage` and `attributes` | `string` | `"-"` | no |
| elasticache\_subnet\_group\_name | Subnet group name for the ElastiCache instance | `string` | `""` | no |
| enabled | Set to false to prevent the module from creating any resources | `bool` | `true` | no |
| engine\_version | Redis engine version | `string` | `"4.0.10"` | no |
| environment | This value is part of the AWS cloud asset tagging strategy to be able to group items by environment. | `string` | n/a | yes |
| existing\_security\_groups | List of existing Security Group IDs to place the cluster into. Set `use_existing_security_groups` to `true` to enable using `existing_security_groups` as Security Groups for the cluster | `list(string)` | `[]` | no |
| family | Redis family | `string` | `"redis4.0"` | no |
| instance\_type | Elastic cache instance type | `string` | `"cache.t2.micro"` | no |
| maintenance\_window | Maintenance window | `string` | `"wed:03:00-wed:04:00"` | no |
| memory\_utilization\_high\_evaluation\_periods | Number of periods to evaluate for the alarm. | `number` | `1` | no |
| memory\_utilization\_high\_period | Duration in seconds to evaluate for the alarm. | `number` | `300` | no |
| memory\_utilization\_high\_threshold | The maximum percentage of memory utilization average. | `number` | `80` | no |
| namespace | Namespace (e.g. `eg` or `cp`) | `string` | `""` | no |
| notification\_topic\_arn | Notification topic arn | `string` | `""` | no |
| ok\_actions | The list of actions to execute when this alarm transitions into an OK state from any other state. Each action is specified as an Amazon Resource Number (ARN) | `list(string)` | `[]` | no |
| owner | This value is part of the AWS cloud asset tagging strategy to be able to group items by owner. | `string` | n/a | yes |
| parameter | A list of Redis parameters to apply. Note that parameters may differ from one Redis family to another | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | `[]` | no |
| port | Redis port | `number` | `6379` | no |
| redis\_fqdn | The subdomain to use for the CNAME record. If not provided then the CNAME record will use var.name. | `string` | `""` | no |
| repo | This value is part of the AWS cloud asset tagging strategy to be able to group items by repo. | `string` | n/a | yes |
| repo\_path | This value is part of the AWS cloud asset tagging strategy to be able to group items by repo and subgroup them by the repos path. | `string` | n/a | yes |
| snapshot\_retention\_limit | The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them. | `number` | `0` | no |
| snapshot\_window | The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster. | `string` | `"06:30-07:30"` | no |
| stage | Stage (e.g. `prod`, `dev`, `staging`) | `string` | `""` | no |
| subnet\_ids | Subnet IDs | `list(string)` | `[]` | no |
| subscription\_pagerduty\_endpoint | Pagerduty endpoint for SNS topic subscription (alarms). | `string` | n/a | yes |
| tags | Additional tags (\_e.g._ map("BusinessUnit","ABC") | `map(string)` | `{}` | no |
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

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

```hcl
    provider "aws" {
      region = var.region
    }

    module "vpc" {
      source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=tags/0.8.1"
      namespace  = var.namespace
      stage      = var.stage
      name       = var.name
      cidr_block = "172.16.0.0/16"
    }

    module "subnets" {
      source               = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=tags/0.18.1"
      availability_zones   = var.availability_zones
      namespace            = var.namespace
      stage                = var.stage
      name                 = var.name
      vpc_id               = module.vpc.vpc_id
      igw_id               = module.vpc.igw_id
      cidr_block           = module.vpc.vpc_cidr_block
      nat_gateway_enabled  = true
      nat_instance_enabled = false
    }

    module "redis" {
      source                     = "git::https://github.com/cloudposse/terraform-aws-elasticache-redis.git?ref=master"
      availability_zones         = var.availability_zones
      namespace                  = var.namespace
      stage                      = var.stage
      zone_id                    = var.zone_id
      vpc_id                     = module.vpc.vpc_id
      allowed_security_groups    = [module.vpc.vpc_default_security_group_id]
      subnets                    = module.subnets.private_subnet_ids
      cluster_size               = var.cluster_size
      instance_type              = var.instance_type
      apply_immediately          = true
      automatic_failover         = false
      engine_version             = var.engine_version
      family                     = var.family
      at_rest_encryption_enabled = var.at_rest_encryption_enabled
      transit_encryption_enabled = var.transit_encryption_enabled

      parameter = [
        {
          name  = "notify-keyspace-events"
          value = "lK"
        }
      ]
    }
  ```
