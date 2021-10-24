package test

import (
	"math/rand"
	"strconv"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// Test the Terraform module in examples/complete using Terratest.
func TestExamplesComplete(t *testing.T) {
	t.Parallel()

	rand.Seed(time.Now().UnixNano())

	randId := strconv.Itoa(rand.Intn(100000))
	attributes := []string{randId}

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/complete",
		Upgrade:      true,
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"fixtures.us-east-2.tfvars"},
		Vars: map[string]interface{}{
			"attributes": attributes,
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	vpcCidr := terraform.Output(t, terraformOptions, "vpc_cidr")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "172.16.0.0/16", vpcCidr)

	// Run `terraform output` to get the value of an output variable
	privateSubnetCidrs := terraform.OutputList(t, terraformOptions, "private_subnet_cidrs")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, []string{"172.16.0.0/19", "172.16.32.0/19"}, privateSubnetCidrs)

	// Run `terraform output` to get the value of an output variable
	publicSubnetCidrs := terraform.OutputList(t, terraformOptions, "public_subnet_cidrs")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, []string{"172.16.96.0/19", "172.16.128.0/19"}, publicSubnetCidrs)

	// Run `terraform output` to get the value of an output variable
	clusterHost := terraform.Output(t, terraformOptions, "cluster_host")
	// Verify we're getting back the outputs we expect
	// assert.Equal(t, "eg-test-redis-test-"+randId+".testing.cloudposse.co", clusterHost)
	assert.Equal(t, "eg-test-redis-test-"+randId+".elasticache-redis-terratest-"+randId+".testing.cloudposse.co", clusterHost)

	// Run `terraform output` to get the value of an output variable
	clusterId := terraform.Output(t, terraformOptions, "cluster_id")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "eg-test-redis-test-"+randId, clusterId)


	terraformOptions.Vars = map[string]interface{}{
		"attributes": attributes,
		"sg_name": "changed",
	}

	terraformOptions.Parallelism = 1

	// This will run `terraform apply` and fail the test if there are any errors
	// We are checking to make sure that changing the security group name
	// does not fail with a dependency error.
	terraform.Apply(t, terraformOptions)

	// Restore parallelism for destroy operation
	terraformOptions.Parallelism = 10
}
