variable "name" {
  description = "The name of the storage account"
}

variable "resource_group_name" {
  description = "Reference to the name of the parent resource group"
}

resource "azurerm_storage_account" "storage_account" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  location                 = "uksouth"
  account_replication_type = "ZRS"
  account_tier             = "Standard"
}