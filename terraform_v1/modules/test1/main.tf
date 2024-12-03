
resource "azurerm_resource_group" "rg-1" {
  location = var.location
  name     = "${var.prefix_name}-rg-${var.environment_short_name}-${var.location_short_name}"
}

