output "vm_name" {
  value = proxmox_vm_qemu.mysql_node.name
}

output "vm_ip_lan" {
  value = var.vm_ip_cidr
}
