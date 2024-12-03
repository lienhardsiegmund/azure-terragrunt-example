locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  project_vars     = read_terragrunt_config(find_in_parent_folders("project.hcl"))

  # Extract the variables for easy access
  subscription_id       = local.environment_vars.locals.subscription_id
  subscription_dev_id   = local.environment_vars.locals.subscription_dev_id
  subscription_id_state = local.project_vars.locals.subscription_id_state

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
      alias = "dev"
      subscription_id = "${local.subscription_dev_id}"
    }
    EOF
}

generate "module_provider" {
  path      = "module_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
      terraform {
      required_providers {
        azurerm = {
          source                = "hashicorp/azurerm"
          version               = "~> 4.0"
          configuration_aliases = [azurerm.dev]
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
  local.environment_vars.locals,
  local.project_vars.locals
)