variable "name" {
  type        = string
  description = "(Required) Specifies the name of the container which should be created within the storage account"
}

variable "storage_account_name" {
  type        = string
  description = "(Required) Specifies the name of the storage account where the container should be created"
}

variable "container_access_type" {
  type        = string
  description = "(Optional) The Access Level configured for this container, possible values are: [blob, container, private]"
  default     = "private"
}