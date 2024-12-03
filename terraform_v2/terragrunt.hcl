locals {
  # Automatically load environment-level variables
  project_vars = read_terragrunt_config(find_in_parent_folders("project.hcl"))
  env_vars     = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract the variables for easy access
  subscription_id_state        = local.project_vars.locals.subscription_id_state
  connectivity_subscription_id = local.project_vars.locals.connectivity_subscription_id
  subscription_id              = local.env_vars.locals.subscription_id

  # tf state configs
  backend_resource_group_name  = "terraform-rg-mon-gwc" # get it from pipeline env var
  backend_storage_account_name = "lsitfstatestmongwc"   # get it from pipeline env var
}

# Generate an Azure provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
    provider "azurerm" {
      features {}
      subscription_id = "${local.subscription_id}"
    }
    provider "azurerm" {
      features {}
      alias = "connectivity"
      subscription_id = "${local.connectivity_subscription_id}"
    }
    EOF
}

generate "module_provider" {
  path      = "test2/module_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
      terraform {
      required_providers {
        azurerm = {
          source                = "hashicorp/azurerm"
          version               = "~> 4.0"
          configuration_aliases = [azurerm.connectivity]
        }
      }
    }
    EOF
}


# Configure Terragrunt to automatically store tfstate files in an Blob Storage container
remote_state {
  backend = "azurerm"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    subscription_id      = local.subscription_id_state
    resource_group_name  = local.backend_resource_group_name
    storage_account_name = local.backend_storage_account_name
    container_name       = "tfstate"
    key                  = "${path_relative_to_include("site")}/terraform.tfstate"
  }
}

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = merge(
  local,
  local.project_vars.locals,
  local.env_vars.locals
)