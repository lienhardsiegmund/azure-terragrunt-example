module "test1" {
  source                 = "./test1"
  environment_short_name = var.environment_short_name
  test1_prefix_name      = var.test1_prefix_name

}
module "test2" {
  source = "./test2"
  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm.connectivity
  }
  environment_short_name = var.environment_short_name
  location               = var.location
  test2_prefix_name      = var.test2_prefix_name
  test1_output           = module.test1.test1_output
}
