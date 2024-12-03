module "test1" {
  source                 = "./modules/test1"
  environment_short_name = "mon"
  prefix_name            = var.test1_prefix_name

}
module "test2" {
  source = "./modules/test2"
  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm.connectivity
  }
  environment_short_name = "con"
  location               = var.location
  prefix_name            = var.test2_prefix_name
  test1_output           = module.test1.test1_output
}
