variable "vm_zones" {
  type    = list(string)
  default = ["1", "2", "3", null]
}

resource "azurerm_managed_disk" "disk" {
  count                = length(var.all_vm_ids)
  name                 = "datadisk-9569-${count.index}"
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10
  zone                 = count.index < 3 ? tostring(count.index + 1) : null
  tags                 = var.tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "attach" {
  count              = length(var.all_vm_ids)
  managed_disk_id    = azurerm_managed_disk.disk[count.index].id
  virtual_machine_id = var.all_vm_ids[count.index]
  lun                = count.index
  caching            = "ReadWrite"
}