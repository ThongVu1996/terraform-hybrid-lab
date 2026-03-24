output "vm_name" {
  value       = module.mysql_vm.vm_name
  description = "Tên của máy ảo MySQL Server"
}

output "vm_ip_lan" {
  value       = module.mysql_vm.vm_ip_lan
  description = "Địa chỉ IP LAN của máy ảo"
}
