output "resource_group_name" { value = module.rgroup.resource_group_name }

output "vnet_name" { value = module.network.vnet_name }
output "subnet_name" { value = module.network.subnet_name }

output "log_analytics_workspace_name" { value = module.common.log_analytics_workspace_name }
output "recovery_services_vault_name" { value = module.common.recovery_services_vault_name }
output "storage_account_name" { value = module.common.storage_account_name }

output "linux_hostnames" { value = module.vmlinux.hostnames }
output "linux_fqdns" { value = module.vmlinux.fqdns }
output "linux_private_ips" { value = module.vmlinux.private_ips }
output "linux_public_ips" { value = module.vmlinux.public_ips }

output "windows_hostname" { value = module.vmwindows.hostname }
output "windows_fqdn" { value = module.vmwindows.fqdn }
output "windows_private_ip" { value = module.vmwindows.private_ip }
output "windows_public_ip" { value = module.vmwindows.public_ip }

output "loadbalancer_name" { value = module.loadbalancer.loadbalancer_name }
output "database_name" { value = module.database.database_name }