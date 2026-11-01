resource "azurerm_postgresql_flexible_server" "db" {
  name                   = "psql-flex-9569"
  resource_group_name    = var.resource_group_name
  location               = var.location
  version                = "13"
  administrator_login    = "psqladmin"
  administrator_password = "P@ssw0rd1234!"
  storage_mb             = 32768
  sku_name               = "B_Standard_B1ms"
  zone                   = "3"
  tags                   = var.tags
}