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