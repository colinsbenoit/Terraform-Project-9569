terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-9569-rg"
    storage_account_name = "tfstate9569sa"
    container_name       = "tfstatefiles"
    key                  = "project-9569.tfstate"
    use_azuread_auth     = true
  }
}