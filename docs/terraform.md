<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3 |
| aws | >= 5.32 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 5.32 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| aws_security_group | cloudposse/security-group/aws | 2.2.0 |
| dns | cloudposse/route53-cluster-hostname/aws | 0.13.0 |
| this | cloudposse/label/null | 0.25.0 |

## Resources

| Name |
|------|
| [aws_cloudwatch_metric_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) |
| [aws_elasticache_parameter_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_parameter_group) |
| [aws_elasticache_replication_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group) |
| [aws_elasticache_serverless_cache](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_serverless_cache) |
| [aws_elasticache_subnet_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_security\_group\_rules | A list of Security Group rule objects to add to the created security group, in addition to the ones<br>this module normally creates. (To suppress the module's rules, set `create_security_group` to false<br>and supply your own security group via `associated_security_group_ids`.)<br>The keys and values of the objects are fully compatible with the `aws_security_group_rule` resource, except<br>for `security_group_id` which will be ignored, and the optional "key" which, if provided, must be unique and known at "plan" time.<br>To get more info see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule . | `list(any)` | `[]` | no |
| additional\_tag\_map | Additional key-value pairs to add to each map in `tags_as_list_of_maps`. Not added to `tags` or `id`.<br>This is for some rare cases where resources want additional configuration of tags<br>and therefore take a list of maps with tag key, value, and additional configuration. | `map(string)` | `{}` | no |
| alarm\_actions | Alarm action list | `list(string)` | `[]` | no |
| alarm\_cpu\_threshold\_percent | CPU threshold alarm level | `number` | `75` | no |
| alarm\_memory\_threshold\_bytes | Ram threshold alarm level | `number` | `10000000` | no |
| allow\_all\_egress | If `true`, the created security group will allow egress on all ports and protocols to all IP address.<br>If this is false and no egress rules are otherwise specified, then no egress will be allowed.<br>Defaults to `true` unless the deprecated `egress_cidr_blocks` is provided and is not `["0.0.0.0/0"]`, in which case defaults to `false`. | `bool` | `null` | no |
| allowed\_cidr\_blocks | DEPRECATED: Use `additional_security_group_rules` instead.<br>Historical description: List of CIDR blocks that are allowed ingress to the cluster's Security Group created in the module | `list(string)` | `[]` | no |
| allowed\_security\_group\_ids | A list of IDs of Security Groups to allow access to the security group created by this module. | `list(string)` | `[]` | no |
| allowed\_security\_groups | DEPRECATED: Use `allowed_security_group_ids` instead. | `list(string)` | `[]` | no |
| apply\_immediately | Apply changes immediately | `bool` | `true` | no |
| associated\_security\_group\_ids | A list of IDs of Security Groups to associate the created resource with, in addition to the created security group.<br>These security groups will not be modified and, if `create_security_group` is `false`, must provide all the required access. | `list(string)` | `[]` | no |
| at\_rest\_encryption\_enabled | Enable encryption at rest | `bool` | `false` | no |
| attributes | ID element. Additional attributes (e.g. `workers` or `cluster`) to add to `id`,<br>in the order they appear in the list. New attributes are appended to the<br>end of the list. The elements of the list are joined by the `delimiter`<br>and treated as a single ID element. | `list(string)` | `[]` | no |
| auth\_token | Auth token for password protecting redis, `transit_encryption_enabled` must be set to `true`. Password must be longer than 16 chars | `string` | `null` | no |
| auto\_minor\_version\_upgrade | Specifies whether minor version engine upgrades will be applied automatically to the underlying Cache Cluster instances during the maintenance window. Only supported if the engine version is 6 or higher. | `bool` | `null` | no |
| automatic\_failover\_enabled | Automatic failover (Not available for T1/T2 instances) | `bool` | `false` | no |
| availability\_zones | Availability zone IDs | `list(string)` | `[]` | no |
| cloudwatch\_metric\_alarms\_enabled | Boolean flag to enable/disable CloudWatch metrics alarms | `bool` | `false` | no |
| cluster\_mode\_enabled | Flag to enable/disable creation of a native redis cluster. `automatic_failover_enabled` must be set to `true`. Only 1 `cluster_mode` block is allowed | `bool` | `false` | no |
| cluster\_mode\_num\_node\_groups | Number of node groups (shards) for this Redis replication group. Changing this number will trigger an online resizing operation before other settings modifications | `number` | `0` | no |
| cluster\_mode\_replicas\_per\_node\_group | Number of replica nodes in each node group. Valid values are 0 to 5. Changing this number will force a new resource | `number` | `0` | no |
| cluster\_size | Number of nodes in cluster. *Ignored when `cluster_mode_enabled` == `true`* | `number` | `1` | no |
| context | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "descriptor_formats": {},<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "labels_as_tags": [<br>    "unset"<br>  ],<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {},<br>  "tenant": null<br>}</pre> | no |
| create\_parameter\_group | Whether new parameter group should be created. Set to false if you want to use existing parameter group | `bool` | `true` | no |
| create\_security\_group | Set `true` to create and configure a new security group. If false, `associated_security_group_ids` must be provided. | `bool` | `true` | no |
| data\_tiering\_enabled | Enables data tiering. Data tiering is only supported for replication groups using the r6gd node type. | `bool` | `false` | no |
| delimiter | Delimiter to be used between ID elements.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| description | Description of elasticache replication group | `string` | `null` | no |
| descriptor\_formats | Describe additional descriptors to be output in the `descriptors` output map.<br>Map of maps. Keys are names of descriptors. Values are maps of the form<br>`{<br>   format = string<br>   labels = list(string)<br>}`<br>(Type is `any` so the map values can later be enhanced to provide additional options.)<br>`format` is a Terraform format string to be passed to the `format()` function.<br>`labels` is a list of labels, in order, to pass to `format()` function.<br>Label values will be normalized before being passed to `format()` so they will be<br>identical to how they appear in `id`.<br>Default is `{}` (`descriptors` output will be empty). | `any` | `{}` | no |
| dns\_subdomain | The subdomain to use for the CNAME record. If not provided then the CNAME record will use var.name. | `string` | `""` | no |
| egress\_cidr\_blocks | DEPRECATED: Use `allow_all_egress` and `additional_security_group_rules` instead.<br>Historical description: Outbound traffic address.<br>Historical default: ["0.0.0.0/0"] | `list(any)` | `null` | no |
| elasticache\_subnet\_group\_name | Subnet group name for the ElastiCache instance | `string` | `""` | no |
| enabled | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| engine\_version | Redis engine version | `string` | `"4.0.10"` | no |
| environment | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| existing\_security\_groups | DEPRECATED: Use `associated_security_group_ids` instead.<br>Historical description: List of existing Security Group IDs to place the cluster into.<br>Set `use_existing_security_groups` to `true` to enable using `existing_security_groups` as Security Groups for the cluster. | `list(string)` | `[]` | no |
| family | Redis family | `string` | `"redis4.0"` | no |
| final\_snapshot\_identifier | The name of your final node group (shard) snapshot. ElastiCache creates the snapshot from the primary node in the cluster. If omitted, no final snapshot will be made. | `string` | `null` | no |
| id\_length\_limit | Limit `id` to this many characters (minimum 6).<br>Set to `0` for unlimited length.<br>Set to `null` for keep the existing setting, which defaults to `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| inline\_rules\_enabled | NOT RECOMMENDED. Create rules "inline" instead of as separate `aws_security_group_rule` resources.<br>See [#20046](https://github.com/hashicorp/terraform-provider-aws/issues/20046) for one of several issues with inline rules.<br>See [this post](https://github.com/hashicorp/terraform-provider-aws/pull/9032#issuecomment-639545250) for details on the difference between inline rules and rule resources. | `bool` | `false` | no |
| instance\_type | Elastic cache instance type | `string` | `"cache.t2.micro"` | no |
| kms\_key\_id | The ARN of the key that you wish to use if encrypting at rest. If not supplied, uses service managed encryption. `at_rest_encryption_enabled` must be set to `true` | `string` | `null` | no |
| label\_key\_case | Controls the letter case of the `tags` keys (label names) for tags generated by this module.<br>Does not affect keys of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper`.<br>Default value: `title`. | `string` | `null` | no |
| label\_order | The order in which the labels (ID elements) appear in the `id`.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present. | `list(string)` | `null` | no |
| label\_value\_case | Controls the letter case of ID elements (labels) as included in `id`,<br>set as tag values, and output by this module individually.<br>Does not affect values of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br>Set this to `title` and set `delimiter` to `""` to yield Pascal Case IDs.<br>Default value: `lower`. | `string` | `null` | no |
| labels\_as\_tags | Set of labels (ID elements) to include as tags in the `tags` output.<br>Default is to include all labels.<br>Tags with empty values will not be included in the `tags` output.<br>Set to `[]` to suppress all generated tags.<br>**Notes:**<br>  The value of the `name` tag, if included, will be the `id`, not the `name`.<br>  Unlike other `null-label` inputs, the initial setting of `labels_as_tags` cannot be<br>  changed in later chained modules. Attempts to change it will be silently ignored. | `set(string)` | <pre>[<br>  "default"<br>]</pre> | no |
| log\_delivery\_configuration | The log\_delivery\_configuration block allows the streaming of Redis SLOWLOG or Redis Engine Log to CloudWatch Logs or Kinesis Data Firehose. Max of 2 blocks. | `list(map(any))` | `[]` | no |
| maintenance\_window | Maintenance window | `string` | `"wed:03:00-wed:04:00"` | no |
| multi\_az\_enabled | Multi AZ (Automatic Failover must also be enabled.  If Cluster Mode is enabled, Multi AZ is on by default, and this setting is ignored) | `bool` | `false` | no |
| name | ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'.<br>This is the only ID element not also included as a `tag`.<br>The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input. | `string` | `null` | no |
| namespace | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique | `string` | `null` | no |
| notification\_topic\_arn | Notification topic arn | `string` | `""` | no |
| ok\_actions | The list of actions to execute when this alarm transitions into an OK state from any other state. Each action is specified as an Amazon Resource Number (ARN) | `list(string)` | `[]` | no |
| parameter | A list of Redis parameters to apply. Note that parameters may differ from one Redis family to another | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | `[]` | no |
| parameter\_group\_description | Managed by Terraform | `string` | `null` | no |
| parameter\_group\_name | Override the default parameter group name | `string` | `null` | no |
| port | Redis port | `number` | `6379` | no |
| preserve\_security\_group\_id | When `false` and `create_before_destroy` is `true`, changes to security group rules<br>cause a new security group to be created with the new rules, and the existing security group is then<br>replaced with the new one, eliminating any service interruption.<br>When `true` or when changing the value (from `false` to `true` or from `true` to `false`),<br>existing security group rules will be deleted before new ones are created, resulting in a service interruption,<br>but preserving the security group itself.<br>**NOTE:** Setting this to `true` does not guarantee the security group will never be replaced,<br>it only keeps changes to the security group rules from triggering a replacement.<br>See the README for further discussion. | `bool` | `false` | no |
| regex\_replace\_chars | Terraform regular expression (regex) string.<br>Characters matching the regex will be removed from the ID elements.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| replication\_group\_id | Replication group ID with the following constraints: <br>A name must contain from 1 to 20 alphanumeric characters or hyphens. <br> The first character must be a letter. <br> A name cannot end with a hyphen or contain two consecutive hyphens. | `string` | `""` | no |
| revoke\_rules\_on\_delete | Instruct Terraform to revoke all of the Security Group's attached ingress and egress rules before deleting<br>the security group itself. This is normally not needed. | `bool` | `false` | no |
| security\_group\_create\_before\_destroy | Set `true` to enable Terraform `create_before_destroy` behavior on the created security group.<br>We only recommend setting this `false` if you are upgrading this module and need to keep<br>the existing security group from being replaced.<br>Note that changing this value will always cause the security group to be replaced. | `bool` | `true` | no |
| security\_group\_create\_timeout | How long to wait for the security group to be created. | `string` | `"10m"` | no |
| security\_group\_delete\_timeout | How long to retry on `DependencyViolation` errors during security group deletion. | `string` | `"15m"` | no |
| security\_group\_description | The description to assign to the created Security Group.<br>Warning: Changing the description causes the security group to be replaced.<br>Set this to `null` to maintain parity with releases <= `0.34.0`. | `string` | `"Security group for Elasticache Redis"` | no |
| security\_group\_name | The name to assign to the security group. Must be unique within the VPC.<br>If not provided, will be derived from the `null-label.context` passed in.<br>If `create_before_destroy` is true, will be used as a name prefix. | `list(string)` | `[]` | no |
| serverless\_cache\_usage\_limits | The usage limits for the serverless cache | `map(string)` | `{}` | no |
| serverless\_enabled | Flag to enable/disable creation of a serverless redis cluster | `bool` | `false` | no |
| serverless\_major\_engine\_version | The major version of the engine to use for the serverless cluster | `string` | `"7"` | no |
| serverless\_snapshot\_time | The daily time that snapshots will be created from the serverless cache. | `string` | `"06:00"` | no |
| serverless\_user\_group\_id | User Group ID to associate with the replication group | `string` | `null` | no |
| snapshot\_arns | A single-element string list containing an Amazon Resource Name (ARN) of a Redis RDB snapshot file stored in Amazon S3. Example: arn:aws:s3:::my\_bucket/snapshot1.rdb | `list(string)` | `[]` | no |
| snapshot\_name | The name of a snapshot from which to restore data into the new node group. Changing the snapshot\_name forces a new resource. | `string` | `null` | no |
| snapshot\_retention\_limit | The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them. | `number` | `0` | no |
| snapshot\_window | The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster. | `string` | `"06:30-07:30"` | no |
| stage | ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| subnets | Subnet IDs | `list(string)` | `[]` | no |
| tags | Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).<br>Neither the tag keys nor the tag values will be modified by this module. | `map(string)` | `{}` | no |
| target\_security\_group\_id | The ID of an existing Security Group to which Security Group rules will be assigned.<br>The Security Group's name and description will not be changed.<br>Not compatible with `inline_rules_enabled` or `revoke_rules_on_delete`.<br>If not provided (the default), this module will create a security group. | `list(string)` | `[]` | no |
| tenant | ID element \_(Rarely used, not included by default)\_. A customer identifier, indicating who this instance of a resource is for | `string` | `null` | no |
| transit\_encryption\_enabled | Set `true` to enable encryption in transit. Forced `true` if `var.auth_token` is set.<br>If this is enabled, use the [following guide](https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/in-transit-encryption.html#connect-tls) to access redis. | `bool` | `true` | no |
| use\_existing\_security\_groups | DEPRECATED: Use `create_security_group` instead.<br>Historical description: Flag to enable/disable creation of Security Group in the module.<br>Set to `true` to disable Security Group creation and provide a list of existing security Group IDs in `existing_security_groups` to place the cluster into.<br>Historical default: `false` | `bool` | `null` | no |
| user\_group\_ids | User Group ID to associate with the replication group | `list(string)` | `null` | no |
| vpc\_id | VPC ID | `string` | n/a | yes |
| zone\_id | Route53 DNS Zone ID as list of string (0 or 1 items). If empty, no custom DNS name will be published.<br>If the list contains a single Zone ID, a custom DNS name will be pulished in that zone.<br>Can also be a plain string, but that use is DEPRECATED because of Terraform issues. | `any` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | Elasticache Replication Group ARN |
| cluster\_enabled | Indicates if cluster mode is enabled |
| endpoint | Redis primary, configuration or serverless endpoint , whichever is appropriate for the given configuration |
| engine\_version\_actual | The running version of the cache engine |
| host | Redis hostname |
| id | Redis cluster ID |
| member\_clusters | Redis cluster members |
| port | Redis port |
| reader\_endpoint\_address | The address of the endpoint for the reader node in the replication group, if the cluster mode is disabled or serverless is being used. |
| security\_group\_id | The ID of the created security group |
| security\_group\_name | The name of the created security group |
| serverless\_enabled | Indicates if serverless mode is enabled |
<!-- markdownlint-restore -->
