# Set common variables for the environment. This is automatically pulled in in the root terragrunt.hcl configuration to
# feed forward to the child modules.
locals {
  subscription_id        = "123456789012345678901234567890"
  subscription_dev_id    = "123456789012345678901234567890"
  environment_short_name = "mon"
}
