# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "${get_parent_terragrunt_dir()}//modules"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

locals {
  subscription_id = "123456789012345678901234567890"
}

inputs = {
  # module test 1
  test1_prefix_name = "test1"

  # module test 2
  test2_prefix_name = "test2"
}