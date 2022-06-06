resource_group_name     = "rg-byk-dev"
resource_group_location = "uksouth"
storage_account_name    = "bykstgdev"

#Keyvault Configuration
keyvault_name                            = "bykkeyvault"
keyvault_enabled_for_deployment          = "true"
keyvault_enabled_for_disk_encryption     = "true"
keyvault_enabled_for_template_deployment = "true"
keyvault_purge_protection_enabled        = "false"

#AKS Configuration
aks_name = "bykaksdev"