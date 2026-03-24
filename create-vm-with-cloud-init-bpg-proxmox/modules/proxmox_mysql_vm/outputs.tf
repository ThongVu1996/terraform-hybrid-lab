output "vm_ip" {
  description = "Địa chỉ IP cố định của MySQL Server đã cài qua cloud-init"
  value       = "172.199.10.150"
}

output "tailscale_login" {
  description = "Hướng dẫn câu lệnh sử dụng Tailscale SSH để kết nối với máy chủ"
  value       = "Sử dụng: 'tailscale ssh thong@db-server' (tùy thuộc hostname) để truy cập."
}
