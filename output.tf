# Outputs the public IP address of the Linux virtual machine
output "linux_vm_ip_address" {
  description = "Virtual Machine public IP Address"
  value       = azurerm_public_ip.linux-vm-ip.ip_address
}

# Outputs the admin username used to access the Linux virtual machine
output "linux_vm_admin_username" {
  description = "Admin username for the Virtual Machine"
  value       = var.linux_admin_username
}