output "hostname" {
  value = azurerm_windows_virtual_machine.vm[*].name
}

output "domain_name" {
  value = azurerm_windows_virtual_machine.vm[*].computer_name
}

output "private_ip" {
  value = azurerm_network_interface.nic[*].private_ip_address
}

output "public_ip" {
  value = azurerm_public_ip.pip[*].ip_address
}

output "fqdn" {
  value = azurerm_public_ip.pip[*].fqdn
}

output "vm_ids" {
  value = azurerm_windows_virtual_machine.vm[*].id
}