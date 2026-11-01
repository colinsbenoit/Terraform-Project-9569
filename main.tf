locals {
  common_tags = {
    Project        = "CCGC 5502 Terraform Project"
    Name           = "colins.lekemo"
    ExpirationDate = "2027-12-31"
    Environment    = "Learning"
  }
}

# 1. Resource Group Module
module "rgroup" {
  source   = "./modules/rgroup-9569"
  location = "indiasouthcentral"
  tags     = local.common_tags
}

# 2. Networking Module (VNET, Subnet, NSG)
module "network" {
  source              = "./modules/network-9569"
  resource_group_name = module.rgroup.resource_group_name
  location            = module.rgroup.location
  tags                = local.common_tags
}

# 3. Common Services Module (Log Analytics, Recovery Vault, Storage)
module "common" {
  source              = "./modules/common-9569"
  resource_group_name = module.rgroup.resource_group_name
  location            = module.rgroup.location
  tags                = local.common_tags
}

# 4. Linux Virtual Machines Module
module "vmlinux" {
  source                        = "./modules/vmlinux-9569"
  resource_group_name           = module.rgroup.resource_group_name
  location                      = module.rgroup.location
  subnet_id                     = module.network.subnet_id
  storage_account_blob_endpoint = module.common.storage_account_blob_endpoint
  tags                          = local.common_tags
}

# 5. Windows Virtual Machine Module
module "vmwindows" {
  source                        = "./modules/vmwindows-9569"
  resource_group_name           = module.rgroup.resource_group_name
  location                      = module.rgroup.location
  subnet_id                     = module.network.subnet_id
  storage_account_blob_endpoint = module.common.storage_account_blob_endpoint
  tags                          = local.common_tags
}

# 6. Data Disks Module (4 x 10 GB)
module "datadisk" {
  source              = "./modules/datadisk-9569"
  resource_group_name = module.rgroup.resource_group_name
  location            = module.rgroup.location
  all_vm_ids          = concat(module.vmlinux.vm_ids, module.vmwindows.vm_ids)
  tags                = local.common_tags
}

# 7. Load Balancer Module
module "loadbalancer" {
  source              = "./modules/loadbalancer-9569"
  resource_group_name = module.rgroup.resource_group_name
  location            = module.rgroup.location
  linux_nic_ids       = module.vmlinux.nic_ids
  tags                = local.common_tags
}

# 8. PostgreSQL Database Module
module "database" {
  source              = "./modules/database-9569"
  resource_group_name = module.rgroup.resource_group_name
  location            = "canadacentral"
  #location            = module.rgroup.location
  tags                = local.common_tags
}