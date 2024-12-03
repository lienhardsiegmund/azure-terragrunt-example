resource "azurerm_resource_group" "rg-1" {
  location = var.location
  name     = "${var.test1_output}-rg-${var.environment_short_name}-${var.location_short_name}"
}

resource "azurerm_resource_group" "rg-2" {
  provider = azurerm.connectivity
  location = var.location
  name     = "${var.test2_prefix_name}-rg-dev-${var.location_short_name}"
}


