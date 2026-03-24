variable "vm_instance_count" {
  description = "Số lượng máy ảo MySQL (Bằng 0 sẽ xóa máy ảo)"
  type        = number
  default     = 1
}

variable "proxmox_template_name" {
  description = "Tên của Template Ubuntu trên Proxmox đã dựng sẵn"
  type        = string
  default     = "ubuntu-template"
}

variable "proxmox_node" {
  description = "Tên node của Proxmox (thường là 'pve')"
  type        = string
  default     = "pve"
}

variable "db_name" {
  description = "Tên database sẽ được tạo trong MySQL tự động qua Cloud-init"
  type        = string
}

variable "db_user" {
  description = "Tên user sẽ được tạo trong MySQL để đăng nhập sử dụng database"
  type        = string
}

variable "db_password" {
  description = "Mật khẩu của database user"
  type        = string
  sensitive   = true
}

variable "user_password" {
  description = "Mật khẩu đăng nhập qua Console/SSH của user 'thong'"
  type        = string
  sensitive   = true
}

variable "proxmox_ssh_private_key" {
  description = "Nội dung Private Key SSH kết nối vào Proxmox (Dùng cho SSH connection blocks) giúp đưa file cấu hình vào bên trong thư mục /var/lib/vz/snippets của máy promox"
  type        = string
  sensitive   = true
}

variable "user_name" {
  description = "Tên user dùng để ssh vào máy vm"
  type        = string
}

variable "vm_ip_cidr" {
  type = string
}

variable "vm_gateway" {
  type = string
}
