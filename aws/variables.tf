variable "AWS_DEFAULT_REGION" {
  description = "Region bạn muốn triển khai (Vd: ap-southeast-1)"
  type        = string
  default     = "ap-southeast-1"
}

variable "vpc_cidr" {
  description = "Dải IP của VPC (Vd: 10.0.0.0/16)"
  type        = string
  default     = "10.0.0.0/16"
}

variable "ts_oauth_client_id" {
  description = "Tailscale OAuth Client ID"
  type        = string
}

variable "ts_oauth_client_secret" {
  description = "Tailscale OAuth Client Secret"
  type        = string
  sensitive   = true
}

variable "db_host_tailscale" {
  description = "Hostname MagicDNS của máy DB ở Proxmox"
  type        = string
}

variable "db_password" {
  description = "Mật khẩu Database trên máy Proxmox"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Tên Database"
  type        = string
}

variable "db_user" {
  description = "User Database"
  type        = string
}

variable "ssh_private_key" {
  description = "Private Key để clone git"
  type        = string
  sensitive   = true
}
