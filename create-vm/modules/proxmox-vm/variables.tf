variable "db_name" {}
variable "db_user" {}
variable "db_password" { sensitive = true }
variable "proxmox_node" {}
variable "user_name" {}
variable "user_password" { sensitive = true }
variable "vm_gateway" {}
variable "vm_ip_cidr" {}
variable "vm_name" {}
variable "vm_template" {}
variable "vm_cores" { type = number }
variable "vm_memory" { type = number }
variable "vm_disk_size" {}
variable "vm_bridge" {}
variable "tailscale_auth_key" { sensitive = true }
