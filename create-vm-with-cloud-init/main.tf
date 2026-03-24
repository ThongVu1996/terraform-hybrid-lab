module "mysql_vm" {
  source = "./modules/proxmox-vm"

  vm_name      = "vm-mysql-server"
  node_name    = var.proxmox_node
  ip_address   = var.vm_ip_cidr
  gateway      = var.vm_gateway
  ssh_user     = var.user_name
  ssh_password = var.user_password

  cloud_init_snippet = "local:snippets/db-setup.yaml"

  cores  = 2
  memory = 4096
}
