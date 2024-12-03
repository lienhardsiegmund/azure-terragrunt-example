# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "${get_parent_terragrunt_dir()}//modules/test2"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  subscription_id  = local.environment_vars.locals.subscription_id
}

# we need to mock output for initial plan
dependency "test1" {
  config_path = "../test1"
  mock_outputs = {
    test1_output = "fake-vpc-id"
  }
}

inputs = {
  prefix_name  = "test2"
  test1_output = dependency.test1.outputs.test1_output

}