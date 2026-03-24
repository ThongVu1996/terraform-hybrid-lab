variable "vpc_id" {
  description = "VPC ID where the EC2 instance will be deployed"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the EC2 instance will be deployed"
  type        = string
}

variable "db_host_tailscale" {
  description = "Tailscale hostname of the database server"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_user" {
  description = "Database user"
  type        = string
}

variable "ssh_private_key" {
  description = "Private key for SSH access"
  type        = string
  sensitive   = true
}
