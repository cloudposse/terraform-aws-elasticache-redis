enabled = true

region = "us-east-2"

availability_zones = ["us-east-2a", "us-east-2b"]

namespace = "eg"

stage = "test"

name = "redis-test"

# Using a large instance vs a micro shaves 5-10 minutes off the run time of the test
instance_type = "cache.m6g.large"

cluster_size = 1

family = "redis6.x"

engine_version = "6.x"

at_rest_encryption_enabled = false

transit_encryption_enabled = true

zone_id = "Z3SO0TKDDQ0RGG"

cloudwatch_metric_alarms_enabled = false
