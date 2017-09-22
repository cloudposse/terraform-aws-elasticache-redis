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
  zone_id         = "${var.route52_zone_id}"
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

  automatic_failover = "false"
}
```


## Input

|  Name                        |  Default            |  Description                                           |
|:-----------------------------|:-------------------:|:-------------------------------------------------------|
| namespace                    |global               |Namespace                                               |
| stage                        |default              |Stage                                                   |
| name                         |redis                |Name                                                    |
| security_groups              |[]                   |AWS security group ids                                  |
| vpc_id                       |__REQUIRED__         |AWS VPC id                                              |
| subnets                      | []                  | AWS subnet ids                                         |
| cluster_size                 | 1                   | Count of nodes in cluster                              |
| instance_type                | cache.t2.micro      | Elastic cache instance type                            |
| family                       | redis3.2            | Redis family                                           |
| engine_version               | 3.2.4               | Redis engine version                                   |
| port                         | 6379                | Redis port                                             |
| maintenance_window           | wed:03:00-wed:04:00 | Maintenance window                                     |
| notification_topic_arn       |                     | Notification topic arn                                 |
| alarm_cpu_threshold_percent  | 75                  | CPU threshold alarm level                              |
| alarm_memory_threshold_bytes | 10000000            | Ram threshold alarm level                              |
| alarm_actions                | []                  | Alarm action list                                      |
| apply_immediately            | true                | Apply changes immediately                              |
| automatic_failover           | false               | Automatic failover (Not available for T1/T2 instances) |
| availability_zones           | []                  | Availability zone ids                                  |
| zone_id                      | false               | Route53 dns zone id                                    |


## Output

| Name              | Description       |
|:------------------|:------------------|
| id                | Redis cluster id  |
| security_group_id | Security group id |
| host              | Redis host        |
| port              | Redis port        |


## License

Apache 2 License. See [`LICENSE`](LICENSE) for full details.
