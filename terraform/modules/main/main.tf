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
  #Despite being over-written in a config file, this is needed so the state file saves 
  backend "azure" {}
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

resource "azurerm_resource_group" "resource_group" {
  name      = var.resource_group_name
  location  = var.resource_group_location
}

module "aks_cluster" {
  source = "../resource_templates"
  
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
    name                = var.aks_cluster_name
    location            = var.location
    resource_group_name = var.resource_group_name
    dns_prefix          = var.aks_cluster_name

    default_node_pool {
        name            = "defaultpool"
        node_count      = 2
        vm_size         = "Standard_D2_v2"
    }

    identity {
    type = "SystemAssigned"
  }

    network_profile {
        load_balancer_sku = "Standard"
        network_plugin = "kubenet"
    }

    tags = {
        Environment = "Development"
    }
}

resource "azurerm_kubernetes_cluster_node_pool" "example" {
  name                  = "internal"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.example.id
  vm_size               = "Standard_DS2_v2"
  node_count            = 1

  tags = {
    Environment = "Production"
  }
}