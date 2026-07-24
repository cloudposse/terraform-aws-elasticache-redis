# Migration Notes

Upgrading this module from a version before 0.41.0 to version
0.41.0 or later will cause the existing security group for
the Elasticache Redis cluster to be deleted and a new one 
to be created, unless you had set ` use_existing_security_groups = true` (which prevents this module from creating and managing a security group for the cluster). There will be some consequences to this, but in most cases the consequences will be tolerable and the
benefits worth upgrading to the new version and leaving
the new `security_group_create_before_destroy` input at the default value of `true`.

##### Consequences

- Any references to the existing managed security group, such as in other security group rules, will become invalid and probably need to be updated with references to the new security group.
- There will be a brief outage (cluster inaccessible) during the period after the existing managed security group has its rules removed and before the cluster is associated with the new security group. This outage is typically under 10 seconds, but there are no guarantees. If you run `terraform apply` with `-parallelism=1` then the first `apply` will probably fail (trying to destroy the existing security group before removing the cluster from it), leaving the cluster inaccessible until you run `apply` again to restore access. This will not happen if you use the default `parallelism` setting of 10.

**If these consequences are acceptable**, then you do not need to take any special actions to upgrade to the newer version of this module.

**If you need the security group ID to remain stable** over time, for example because you want to reference the ID elsewhere, then you should not have this module managing the security group, and should have already set `use_existing_security_groups = true`. If you failed to do that before but now want that option:

- Update the reference to this module to point to the current version.
- Replace the existing `use_existing_security_groups` input, if any, with the new `create_security_group` input and set it to  `false`.
- Run `terraform plan` and make note of the resource addresses of the `aws_security_group` and `aws_security_group_rule` resources that Terraform plans to destroy. Use `terraform state rm` to remove them from the Terraform state.
- Update the ` associated_security_group_ids` input to include the ID of the existing security group. Note that this ID will no longer be output as the `cluster_security_group_id`, so adjust anything that was relying on that output.
- (Optional) Use the [terraform-aws-security-group](https://github.com/cloudposse/terraform-aws-security-group) module to manage the existing security group, setting the `target_security_group_id` to the existing security group's ID. Manually (via `aws` CLI or AWS web console) delete the abandoned security group rules after `terraform-aws-security-group` creates the new ones.

**If you are OK with the security group ID changing but need absolutely zero downtime** you will benefit from the module's new "create before destroy" behavior for the managed security group, but want to do a targeted `terraform apply` to ensure zero downtime.

- Update the reference to this module to point to the current version.

- Run `terraform plan` and take note of the resource addresses of the `aws_security_group` and `aws_security_group_rule` resources that will be created.

- Run `terraform apply -target <address1> -target <address2>...` with those addresses. Your resource addresses will vary depending on your root module and rules, but it will be something like

  ```hcl
  tf apply \
    -target='module.x.module.aws_security_group.aws_security_group.cbd[0]' \
    -target='module.x.module.aws_security_group.aws_security_group_rule.keyed["_allow_all_egress_"]' \
    -target='module.x.module.aws_security_group.aws_security_group_rule.keyed["in#in#sg#0"]'
  ```

- Run `terraform plan`, verify that there are no resources to be added, and take note of the resource address of the `aws_elasticache_replication_group` resource that will be updated.

- Run `terraform apply -target <address>` with the address of the `aws_elasticache_replication_group`. Your resource address will vary depending on your root module, but it will be something like

  ```hcl
  tf apply -target='module.x.aws_elasticache_replication_group.default[0]'
  
  ```

- Run `terraform apply` one last time to finish any other tasks.

