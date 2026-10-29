variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for the VM"
}

variable "storage_account_blob_endpoint" {
  type        = string
  description = "Primary blob endpoint for boot diagnostics"
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}

variable "windows_vm_count" {
  type        = number
  default     = 1
  description = "Number of Windows VMs to deploy"
}