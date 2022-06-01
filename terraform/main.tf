data "azurerm_client_config" "current" {}

module "resource_group" {
  source                  = "./modules/resource_templates/resource_group"
  resource_group_name     = var.resource_group_name
  resource_group_location = var.resource_group_location
}

module "key_vault" {
  source                                   = "./modules/resource_templates/key_vault"
  resource_group_name                      = module.resource_group.resource_group_name
  keyvault_name                            = var.keyvault_name
  keyvault_location                        = var.resource_group_location
  keyvault_tenant_id                       = data.azurerm_client_config.current.tenant_id
  keyvault_enabled_for_deployment          = var.keyvault_enabled_for_deployment
  keyvault_enabled_for_disk_encryption     = var.keyvault_enabled_for_disk_encryption
  keyvault_enabled_for_template_deployment = var.keyvault_enabled_for_template_deployment
  keyvault_purge_protection_enabled        = var.keyvault_purge_protection_enabled
}

module "aks" {
  source              = "./modules/resource_templates/aks"
  aks_name            = var.aks_name
  resource_group_name = module.resource_group.resource_group_name
  depends_on          = [module.resource_group]
}