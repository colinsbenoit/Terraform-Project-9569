output "hostnames" {
  value = [for vm in azurerm_linux_virtual_machine.vm : vm.name]
}

output "fqdns" {
  value = [for pip in azurerm_public_ip.pip : pip.fqdn]
}

output "private_ips" {
  value = [for nic in azurerm_network_interface.nic : nic.private_ip_address]
}

output "public_ips" {
  value = [for pip in azurerm_public_ip.pip : pip.ip_address]
}

output "vm_ids" {
  value = [for vm in azurerm_linux_virtual_machine.vm : vm.id]
}

output "nic_ids" {
  value = [for nic in azurerm_network_interface.nic : nic.id]
}