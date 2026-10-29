resource "azurerm_public_ip" "pip" {
  for_each            = var.linux_vms
  name                = "pip-linux-9569-${each.key}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "dns-linux-9569-${each.key}"
  zones               = [each.value.zone]
  tags                = var.tags
}

resource "azurerm_network_interface" "nic" {
  for_each            = var.linux_vms
  name                = "nic-linux-9569-${each.key}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip[each.key].id
  }
  tags = var.tags
}

resource "azurerm_linux_virtual_machine" "vm" {
  for_each            = var.linux_vms
  name                = "vm-linux-9569-${each.key}"
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = "Standard_B1s"
  admin_username      = var.admin_username
  zone                = each.value.zone

  network_interface_ids = [azurerm_network_interface.nic[each.key].id]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.public_key_path)
  }

  os_disk {
    name                 = "osdisk-linux-9569-${each.key}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

 source_image_reference {
    publisher = "almalinux"
    offer     = "almalinux-x86_64"
    sku       = "8-gen2"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = var.storage_account_blob_endpoint
  }

  tags = var.tags
}

resource "azurerm_virtual_machine_extension" "network_watcher" {
  for_each                   = var.linux_vms
  name                       = "NetworkWatcherAgentLinux"
  virtual_machine_id         = azurerm_linux_virtual_machine.vm[each.key].id
  publisher                  = "Microsoft.Azure.NetworkWatcher"
  type                       = "NetworkWatcherAgentLinux"
  type_handler_version       = "1.4" # <-- Version compatible mise à jour
  auto_upgrade_minor_version = true
  tags                       = var.tags
}

resource "azurerm_virtual_machine_extension" "azure_monitor" {
  for_each                   = var.linux_vms
  name                       = "AzureMonitorLinuxAgent"
  virtual_machine_id         = azurerm_linux_virtual_machine.vm[each.key].id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
  tags                       = var.tags
} 