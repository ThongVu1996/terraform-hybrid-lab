module "mysql_vm" {
  source = "./modules/proxmox-vm"

  # Biến cho VM
  vm_name      = var.vm_name
  proxmox_node = var.proxmox_node
  vm_template  = var.vm_template
  vm_cores     = var.vm_cores
  vm_memory    = var.vm_memory
  vm_disk_size = var.vm_disk_size
  vm_bridge    = var.vm_bridge

  # Biến mạng
  vm_ip_cidr = var.vm_ip_cidr
  vm_gateway = var.vm_gateway

  # Biến tài khoản
  user_name     = var.user_name
  user_password = var.user_password

  # Biến Database
  db_name     = var.db_name
  db_user     = var.db_user
  db_password = var.db_password

  # Tailscale
  tailscale_auth_key = var.tailscale_auth_key
}
