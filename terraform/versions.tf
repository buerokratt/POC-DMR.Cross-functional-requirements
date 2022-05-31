# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.5.0"
    }
  }
  required_version = ">= 1.1.0"

  backend "local" {
    path = "/terraform.tfstate"
  }
}

provider "azurerm" {
  client_id       = "1964b6aa-c64a-4922-af15-df116b1de6fc"
  client_secret   = "hVf8Q~.mfx-UaHul6SOIN9Mp2xd2KoCj4DLL0aQu"
  tenant_id       = "72f988bf-86f1-41af-91ab-2d7cd011db47"
  subscription_id = "7bfb919f-e6c4-406e-90ba-e6d3745f5eea"
  features {}
}