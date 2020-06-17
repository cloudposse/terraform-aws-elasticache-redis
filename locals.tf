module "unique_name" {
  source = "git@github.com:opploans/terraform-opploans-unique-resource-name?ref=v0.2.0"

  environment = var.environment
  application = var.application
}

locals {
  common_tags = {
    Name        = local.resource_name
    Environment = var.environment
    Application = var.application
    Owner       = var.owner
    Repo        = var.repo
    RepoPath    = var.repo_path
    Tool        = "terraform"
  }

  tags                 = merge(local.common_tags, var.additional_tags)
  resource_name        = module.unique_name.resource_name
  unique_resource_name = module.unique_name.unique_resource_name
}