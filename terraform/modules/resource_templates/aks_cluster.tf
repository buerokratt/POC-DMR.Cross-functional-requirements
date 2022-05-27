variable "name" {
  type = string
  description = "(Required) The name of the Managed Kubernetes Cluster"
}

variable "location" {
  type = string
  description = "(Required) The location where the Managed Kubernetes Cluster should be created"
}

variable "resource_group_name" {
  type = string
  description = "(Required) Specifies the Resource Group where the Managed Kubernetes Cluster should exist"
}

variable "dns_prefix" {
  type = string
  description = "(Optional) DNS prefix specified when creating the managed cluster"
}

variable "default_node_pool_name" {
  type = string
  description = "(Required) Specifies the name of the default node pool"
}

variable "default_node_pool_count" {
  type = number
  description = "(Required) Specifies the count of the default node pool node count"
}

variable "default_node_pool_vm_size" {
  type = string
  description = "(Required) Specifies the size of the default node pool vm size"
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                      = var.name
  location                  = var.location
  resource_group_name       = var.resource_group_name
  dns_prefix                = var.dns_prefix

  default_node_pool {
    name                    = var.default_node_pool_name
    count                   = var.default_node_pool_count
    vm_size                 = var.default_node_pool_vm_size
  }
}

output "id" {
  value       = azurerm_kubernetes_cluster.aks_cluster.id
  description = "Specifies the resource id of the AKS cluster."
}