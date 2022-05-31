variable "resource_group_name" {
  type        = string
  description = "The name of the resource group"
}

variable "storage_account_name" {
  type        = string
  description = "The name of the storage account"
}

module "resource_group" {
  source              = "./modules/resource_templates/resource_group"
  resource_group_name = var.resource_group_name
}

module "storage_account" {
  source              = "./modules/resource_templates/storage_account"
  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
  depends_on          = [module.resource_group]
}