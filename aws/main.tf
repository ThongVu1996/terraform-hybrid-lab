# 1. Khởi tạo Hạ tầng mạng (VPC, Subnet, v.v.)
module "network" {
  source   = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
}

# 2. Khởi tạo Máy chủ Web & Cài đặt phần mềm
module "web_server" {
  source            = "./modules/ec2"
  vpc_id            = module.network.vpc_id
  subnet_id         = module.network.public_subnet_id
  db_host_tailscale = var.db_host_tailscale
  db_password       = var.db_password
  db_name           = var.db_name
  db_user           = var.db_user
  ssh_private_key   = var.ssh_private_key
}
