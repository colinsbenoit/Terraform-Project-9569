resource "azurerm_availability_set" "win_avset" {
  name                         = "win-avset-9569"
  location                     = var.location
  resource_group_name          = var.resource_group_name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 5
  managed                      = true
  tags                         = var.tags
}

resource "azurerm_public_ip" "pip" {
  count               = var.windows_vm_count
  name                = "pip-win-9569-${count.index}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "win-9569-${count.index}"
  tags                = var.tags
}

resource "azurerm_network_interface" "nic" {
  count               = var.windows_vm_count
  name                = "nic-win-9569-${count.index}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip[count.index].id
  }
  tags = var.tags
}

resource "azurerm_windows_virtual_machine" "vm" {
  count               = var.windows_vm_count
  name                = "vm-win-9569-${count.index}"
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = "Standard_B2s"
  admin_username      = "winadmin"
  admin_password      = "P@ssw0rd1234!"
  availability_set_id = azurerm_availability_set.win_avset.id

  network_interface_ids = [
    azurerm_network_interface.nic[count.index].id,
  ]

  os_disk {
    name                 = "osdisk-win-9569-${count.index}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = var.storage_account_blob_endpoint
  }

  tags = var.tags
}

resource "azurerm_virtual_machine_extension" "antimalware" {
  count                      = var.windows_vm_count
  name                       = "IaaSAntimalware"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm[count.index].id
  publisher                  = "Microsoft.Azure.Security"
  type                       = "IaaSAntimalware"
  type_handler_version       = "1.5"
  auto_upgrade_minor_version = true

  settings = jsonencode({
    AntimalwareEnabled        = true
    RealtimeProtectionEnabled = "true"
    ScheduledScanSettings = {
      isEnabled = "true"
      scanType  = "Quick"
      day       = "7"
      time      = "120"
    }
    Exclusions = {
      Extensions = ""
      Paths      = ""
      Processes  = ""
    }
  })

  tags = var.tags
}