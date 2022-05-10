variable "resource_group_name" {
  type        = string
  description = "The name of the resource group"
}

variable "storage_account_name" {
  type        = string
  description = "The name of the storage account"
}

# Configure the Azure provider
terraform {
  backend "azurerm" {}
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.5.0"
    }
  }
  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

#Test
resource "azurerm_storage_container" "test_container" {
  name                  = "test2"
  storage_account_name  = var.storage_account_name
  container_access_type = "private"
}








