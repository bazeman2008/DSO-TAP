variable "resource_group_name" {
  type        = string
  default     = "rg-test-01"
  description = "test deployment."
}

variable "resource_group_location" {
  type        = string
  default     = "eastus"
  description = "Location of the Azure resource group."
}

variable "subscription_id" {
  type        = string
  default     = "bc46e754-b024-4c42-84a6-4a8db22f4359"
  description = "Azure subscription ID"
}
