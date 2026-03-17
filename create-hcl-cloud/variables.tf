variable "tfc_token" {
  description = "User API Token lấy từ môi trường terminal"
  type        = string
  sensitive   = true
}

variable "org_name" {
  type    = string
  default = "tonytechlab-enterprise-2026"
}

variable "org_email" {
  type    = string
  default = "admin@tonytechlab.com"
}

variable "project_name" {
  type    = string
  default = "Internal-Services"
}

variable "agent_pool_name" {
  type    = string
  default = "proxmox-home-pool"
}

variable "workspace_name" {
  type    = string
  default = "mysql-automation-project"
}
