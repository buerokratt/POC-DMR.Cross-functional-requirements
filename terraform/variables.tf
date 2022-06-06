variable "resource_group_name" {
  type        = string
  description = "The name of the resource group"
}

variable "resource_group_location" {
  type        = string
  description = "The location of the resource group"
}

variable "storage_account_name" {
  type        = string
  description = "The name of the storage account"
}

variable "aks_name" {
  description = "Name of the azure kubernetes cluster"
  type        = string
}

variable "client_id" {
  description = "The service principal's client ID"
  type        = string
}

variable "client_secret" {
  description = "The service principal's client secret"
  type        = string
}

variable "tenant_id" {
  description = "The directory/tenent that the service principal lives in"
  type        = string
}

variable "subscription_id" {
  description = "The subscription that terraform will deploy to"
  type        = string
}

variable "keyvault_name" {
  description = "Key vault name"
  type        = string
}

variable "keyvault_enabled_for_deployment" {
  description = "true/false for VMs to able to fetch secrets/keys/certificates"
  type        = bool
}

variable "keyvault_enabled_for_disk_encryption" {
  description = "true/false for usage of secrets/keys/certificates for disk encryption"
  type        = bool
}

variable "keyvault_enabled_for_template_deployment" {
  description = "true/false for deployments to able to fetch secrets/keys/certificates"
  type        = bool
}
variable "keyvault_purge_protection_enabled" {
  description = "true/false for enabling purge protection"
  type        = bool
}