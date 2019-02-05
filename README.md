# terraform-aws-elasticache-redis

Terraform module to provision an [`ElastiCache`](https://aws.amazon.com/elasticache/) Redis Cluster


## Usage

Include this repository as a module in your existing terraform code:

```hcl
module "example_redis" {
  source          = "git::https://github.com/cloudposse/terraform-aws-elasticache-redis.git?ref=master"
  namespace       = "general"
  name            = "redis"
  stage           = "prod"
  zone_id         = "${var.route53_zone_id}"
  security_groups = ["${var.security_group_id}"]

  vpc_id                       = "${var.vpc_id}"
  subnets                      = "${var.private_subnets}"
  maintenance_window           = "wed:03:00-wed:04:00"
  cluster_size                 = "2"
  instance_type                = "cache.t2.micro"
  engine_version               = "3.2.4"
  alarm_cpu_threshold_percent  = "${var.cache_alarm_cpu_threshold_percent}"
  alarm_memory_threshold_bytes = "${var.cache_alarm_memory_threshold_bytes}"
  apply_immediately            = "true"
  availability_zones           = "${var.availability_zones}"

  snapshot_window              = "03:00-04:00"
  snapshot_name                = "redis-snapshot"
  snapshot_retention_limit     = "50"
  snapshot_arns                = "${var.snapshot_arns}"

  automatic_failover = "false"
}
```


## Input

|  Name                        |  Default            |  Description                                                    |
|:-----------------------------|:-------------------:|:----------------------------------------------------------------|
| enabled                      | true                | Set to false to prevent the module from creating any resources  |
| namespace                    | global              | Namespace                                                       |
| stage                        | default             | Stage                                                           |
| name                         | redis               | Name                                                            |
| security_groups              | []                  | AWS security group ids                                          |
| vpc_id                       | __REQUIRED__        | AWS VPC id                                                      |
| subnets                      | []                  | AWS subnet ids                                                  |
| cluster_size                 | 1                   | Count of nodes in cluster                                       |
| instance_type                | cache.t2.micro      | Elastic cache instance type                                     |
| family                       | redis3.2            | Redis family                                                    |
| engine_version               | 3.2.4               | Redis engine version                                            |
| port                         | 6379                | Redis port                                                      |
| maintenance_window           | wed:03:00-wed:04:00 | Maintenance window                                              |
| notification_topic_arn       |                     | Notification topic arn                                          |
| alarm_cpu_threshold_percent  | 75                  | CPU threshold alarm level                                       |
| alarm_memory_threshold_bytes | 10000000            | Ram threshold alarm level                                       |
| alarm_actions                | []                  | Alarm action list                                               |
| apply_immediately            | true                | Apply changes immediately                                       |
| automatic_failover           | false               | Automatic failover (Not available for T1/T2 instances)          |
| availability_zones           | []                  | Availability zone ids                                           |
| zone_id                      | false               | Route53 DNS Zone id                                             |
| attributes                   | []                  | Additional attributes (_e.g._ "1")                              |
| tags                         | {}                  | Additional tags (_e.g._ map("BusinessUnit","ABC")               |
| delimiter                    | -                   | Delimiter between `name`, `namespace`, `stage` and `attributes` |
| snapshot_window              |                     | Window for snapshots (hh24:mm-hh24mm)                           |
| snapshot_name                |                     | Name of the snapshot                                            |
| snapshot_retention_limit     | 0                   | Number of snapshots to retain                                   |
| snapshot_arns                | []                  | ARN of the snapshots                                            |



## Output

| Name              | Description       |
|:------------------|:------------------|
| id                | Redis cluster id  |
| security_group_id | Security group id |
| host              | Redis host        |
| port              | Redis port        |


## License

Apache 2 License. See [`LICENSE`](LICENSE) for full details.
