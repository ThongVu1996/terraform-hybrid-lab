output "vm_ip" {
  value       = module.mysql_vm.vm_ip
  description = "Địa chỉ IP cố định của MySQL Server cài đặt bằng cloud init"
}

output "mysql_status" {
  value       = "MySQL is being installed and configured..."
  description = "Trạng thái của tiến trình cài đặt"
}
