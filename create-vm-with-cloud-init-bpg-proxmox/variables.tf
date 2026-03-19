variable "proxmox_api_url_thong" {
  description = "Địa chỉ API Proxmox (Vd: https://1.2.3.4:8006/)"
}
variable "tailscale_auth_key" {
  description = "Tailscale Auth Key để tự động join mạng"
  sensitive   = true
}
variable "proxmox_root_password" {
  description = "Mật khẩu root của node Proxmox để upload file"
  sensitive   = true
}
variable "proxmox_template_name" {
  type        = string
  description = "Tên của Template Ubuntu trên Proxmox"
  default     = "ubuntu-template"
}
variable "proxmox_api_token_id_thong" {}
variable "proxmox_api_token_secret_thong" {}
variable "proxmox_node_thong" {
  default = "pve"
}
variable "db_name_thong" {}
variable "db_user_thong" {}
variable "db_password_thong" {
  sensitive = true
}
variable "ssh_password" {
  sensitive = true
}
variable "proxmox_ssh_private_key" {
  description = "Nội dung Private Key SSH để Connect vào Proxmox Node (Lấy từ HCP Terraform)"
  type        = string
  sensitive   = true
}
