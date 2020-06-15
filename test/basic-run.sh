#! /bin/sh

terragrunt plan-all && terragrunt apply-all --terragrunt-non-interactive || true && terragrunt destroy-all --terragrunt-non-interactive
