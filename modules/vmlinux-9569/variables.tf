variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "subnet_id" { type = string }
variable "storage_account_blob_endpoint" { type = string }
variable "tags" { type = map(string) }

variable "linux_vms" {
  type = map(object({
    zone = string
  }))
  default = {
    "vm1" = { zone = "1" }
    "vm2" = { zone = "2" }
    "vm3" = { zone = "3" }
  }
}

variable "admin_username" { 
  default = "n01769569" 
}

variable "public_key_path" { 
  default = "~/.ssh/id_rsa.pub" 
}

variable "private_key_path" { 
  default = "~/.ssh/id_rsa" 
}