module "data_environment" {
  source      = "git@github.com:opploans/terraform-data-environment.git?ref=v2.2.1"
  environment = var.environment
  aws_profile = var.aws_profile
}
