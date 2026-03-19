output "vm_ip" {
  value       = "172.199.10.150"
  description = "Địa chỉ IP cố định của MySQL Server cài đặt bằng cloud init"
}

output "tailscale_login" {
  value = "Dung: 'tailscale ssh thong@mysql-lab-thong-bpg' để truy cập."
}
