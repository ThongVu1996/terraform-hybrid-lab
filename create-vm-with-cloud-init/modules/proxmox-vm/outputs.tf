output "vm_ip" {
  value       = var.ip_address
  description = "The configured IP address of the VM"
}

output "vm_name" {
  value       = proxmox_vm_qemu.vm.name
  description = "The name of the deployed VM"
}
