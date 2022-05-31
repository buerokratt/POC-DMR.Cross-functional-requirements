variable "resource_group_name" {
  description = "Name of the resource group"
}

resource "azurerm_resource_group" "name" {
  name     = var.resource_group_name
  location = "uksouth"
}