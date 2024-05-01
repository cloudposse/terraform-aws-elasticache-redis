enabled = true

region = "us-east-2"

availability_zones = ["us-east-2a", "us-east-2b"]

namespace = "eg"

stage = "test"

name = "redis-serverless"

serverless_enabled = true

serverless_major_engine_version = "7"

serverless_cache_usage_limits = {
  data_storage_max    = 10
  data_storage_unit   = "GB"
  ecpu_per_second_max = 5000
}

at_rest_encryption_enabled = false

zone_id = "Z3SO0TKDDQ0RGG"

