resource "null_resource" "display_hostnames" {
  for_each = var.linux_vms

  depends_on = [azurerm_linux_virtual_machine.vm]

  provisioner "remote-exec" {
    inline = [
      "echo Hostname: $(hostname)"
    ]

    connection {
      type        = "ssh"
      user        = var.admin_username
      private_key = file(var.private_key_path)
      host        = azurerm_public_ip.pip[each.key].ip_address
    }
  }
}