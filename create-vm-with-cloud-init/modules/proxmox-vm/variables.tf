variable "node_name" {
  type        = string
  description = "The target Proxmox node"
}

variable "vm_name" {
  type        = string
  description = "The name of the VM"
}

variable "template_name" {
  type        = string
  description = "The name of the VM template to clone"
  default     = "ubuntu-template"
}

variable "cores" {
  type        = number
  description = "Number of CPU cores"
  default     = 2
}

variable "memory" {
  type        = number
  description = "Amount of memory in MB"
  default     = 4096
}

variable "ip_address" {
  type        = string
  description = "IP Address in CIDR format (e.g., 172.199.10.151/24)"
}

variable "gateway" {
  type        = string
  description = "Gateway IP address"
}

variable "ssh_user" {
  type        = string
  description = "SSH User"
  default     = "thong"
}

variable "ssh_password" {
  type        = string
  description = "SSH Password"
  sensitive   = true
}

variable "cloud_init_snippet" {
  type        = string
  description = "Path to cloud-init snippet on Proxmox"
  default     = "local:snippets/db-setup.yaml"
}
