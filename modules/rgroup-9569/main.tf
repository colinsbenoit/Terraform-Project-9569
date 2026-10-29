resource "azurerm_resource_group" "rg" {
  name     = "9569-RG"
  location = var.location
  tags     = var.tags
}