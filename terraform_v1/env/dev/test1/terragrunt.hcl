# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "${get_parent_terragrunt_dir()}//modules/test1"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

locals {
  environment_vars       = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  environment_short_name = local.environment_vars.locals.environment_short_name

}

inputs = {
  prefix_name = "test1-${local.environment_short_name}"

}
