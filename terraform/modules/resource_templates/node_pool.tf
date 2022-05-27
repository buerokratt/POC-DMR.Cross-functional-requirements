variable "name" {
  type = string
  description = "(Required) The name of the Node Pool"
}

variable "kubernetes_cluster_id" {
  type = string
  description = "(Required) The ID of the Kubernetes Cluster where this Node Pool should exist"
}

variable "vm_size" {
  type = string
  description = "(Required) The SKU which should be used for the Virtual Machines used in this Node Pool"
}

variable "node_count" {
    type = number
    description = "(Optional) The initial number of nodes which should exist within this Node Pool. Valid values are between 0 and 1000 (inclusive)"
}

resource "azurerm_kubernetes_cluster_node_pool" "node_pool" {
  name                  = var.name
  kubernetes_cluster_id = var.kubernetes_cluster_id
  vm_size               = var.vm_size
  node_count            = var.node_count
}

output "id" {
  description = "Specifies the resource id of the node pool"
  value = azurerm_kubernetes_cluster_node_pool.node_pool.id
}