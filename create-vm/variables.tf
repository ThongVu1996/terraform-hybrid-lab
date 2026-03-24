# === Variables from HCP Screenshots ===

variable "db_name" {
  description = "Tên database MySQL sẽ được tạo"
  type        = string
  default     = "appdb"
}

variable "db_user" {
  description = "Tên user Database MySQL sẽ được tạo"
  type        = string
  default     = "appuser"
}

variable "db_password" {
  description = "Mật khẩu của user database (lấy từ TF_VAR_db_password)"
  type        = string
  sensitive   = true
}

variable "proxmox_node" {
  description = "Tên node Proxmox để deploy VM"
  type        = string
  default     = "promox"
}

variable "proxmox_ssh_private_key" {
  description = "Private key để SSH vào Proxmox host (nếu cần)"
  type        = string
  sensitive   = true
  default     = ""
}

variable "user_name" {
  description = "Username để SSH vào máy ảo VM sau khi tạo"
  type        = string
  default     = "thong"
}

variable "user_password" {
  description = "Mật khẩu của user SSH (lấy từ TF_VAR_user_password)"
  type        = string
  sensitive   = true
}

variable "vm_gateway" {
  description = "Default gateway của máy ảo"
  type        = string
  default     = "172.199.10.1"
}

variable "vm_ip_cidr" {
  description = "Địa chỉ IP cố định của máy ảo kèm CIDR (Ví dụ: 172.199.10.150/24)"
  type        = string
  default     = "172.199.10.150/24"
}

# === Additional Configuration Variables (Rất cần khi làm Module) ===

variable "vm_name" {
  description = "Tên định danh của máy ảo trên Proxmox"
  type        = string
  default     = "vm-mysql-server"
}

variable "vm_template" {
  description = "Tên template Ubuntu Cloud-init đã có sẵn trên Proxmox"
  type        = string
  default     = "ubuntu-template"
}

variable "vm_cores" {
  description = "Số lượng core CPU cho máy ảo"
  type        = number
  default     = 2
}

variable "vm_memory" {
  description = "Bộ nhớ RAM (MB) cho máy ảo"
  type        = number
  default     = 4096
}

variable "vm_disk_size" {
  description = "Dung lượng ổ cứng cho máy ảo (Ví dụ: 32G)"
  type        = string
  default     = "32G"
}

variable "vm_bridge" {
  description = "Bridge mạng của Proxmox (thường là vmbr0)"
  type        = string
  default     = "vmbr0"
}

variable "tailscale_auth_key" {
  description = "Auth key để máy ảo tự động join vào Tailscale network"
  type        = string
  sensitive   = true
}

