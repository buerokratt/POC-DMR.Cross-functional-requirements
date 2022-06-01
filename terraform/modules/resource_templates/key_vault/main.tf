data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "keyvault" {
  name                = var.keyvault_name
  tenant_id           = var.keyvault_tenant_id
  location            = var.keyvault_location
  resource_group_name = var.resource_group_name

  sku_name = "standard"

  enabled_for_deployment          = var.keyvault_enabled_for_deployment
  enabled_for_disk_encryption     = var.keyvault_enabled_for_disk_encryption
  enabled_for_template_deployment = var.keyvault_enabled_for_template_deployment
  purge_protection_enabled        = var.keyvault_purge_protection_enabled
}

resource "azurerm_key_vault_access_policy" "deployer" {
  key_vault_id = azurerm_key_vault.keyvault.id
  tenant_id    = azurerm_key_vault.keyvault.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions = [
    "Get", "List", "Update", "Create", "Import", "Delete", "Restore", "Purge"
  ]

  secret_permissions = [
    "Get", "List", "Set", "Delete", "Purge"
  ]

  certificate_permissions = [
    "Get", "List", "Update", "Create", "Import", "Delete", "Restore", "Purge"
  ]
}


