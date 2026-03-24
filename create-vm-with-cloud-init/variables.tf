variable "proxmox_node" {
  type        = string
  description = "The Proxmox node to deploy to"
}

variable "db_name" {
  type        = string
  description = "The database name"
}

variable "db_user" {
  type        = string
  description = "The database user"
}

variable "db_password" {
  type        = string
  description = "The database password"
  sensitive   = true
}

variable "user_name" {
  type        = string
  description = "SSH User name"
}

variable "user_password" {
  type        = string
  description = "Password for the SSH user"
  sensitive   = true
}

variable "vm_gateway" {
  type        = string
  description = "Gateway for the VM"
}

variable "vm_ip_cidr" {
  type        = string
  description = "CIDR block for the VM IP"
}

variable "proxmox_ssh_private_key" {
  type        = string
  description = "SSH private key for agent"
  sensitive   = true
}
