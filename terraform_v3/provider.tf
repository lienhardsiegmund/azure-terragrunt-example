terraform {
  required_version = "~> 1.7"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

provider "azurerm" {
  alias                           = "connectivity"
  subscription_id                 = var.connectivity_subscription_id
  storage_use_azuread             = true # we want to disable shared access keys for storage accounts, therefore we must tell terraform to use azuread auth instead
  resource_provider_registrations = "none"

  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }

    api_management {
      purge_soft_delete_on_destroy = true
      recover_soft_deleted         = true
    }
  }
}
