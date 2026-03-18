variable "proxmox_api_url_thong" {}
variable "tailscale_auth_key" { sensitive = true }
variable "proxmox_api_token_id_thong" {}
variable "proxmox_api_token_secret_thong" {}
variable "proxmox_node_thong" {}
variable "db_name_thong" {}
variable "db_user_thong" {}
variable "db_password_thong" {}
variable "ssh_password" {
  sensitive = true
}
