resource "proxmox_vm_qemu" "mysql_node" {
  name        = var.vm_name
  target_node = var.proxmox_node

  clone      = var.vm_template
  full_clone = true
  agent      = 1
  os_type    = "cloud-init"

  cpu {
    cores   = var.vm_cores
    sockets = 1
  }
  memory = var.vm_memory
  scsihw = "virtio-scsi-pci"
  boot   = "order=scsi0;net0"

  disk {
    slot    = "ide2"
    type    = "cloudinit"
    storage = "local-lvm"
  }

  disk {
    slot    = "scsi0"
    size    = var.vm_disk_size
    type    = "disk"
    storage = "local-lvm"
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = var.vm_bridge
  }

  ipconfig0  = "ip=${var.vm_ip_cidr},gw=${var.vm_gateway}"
  nameserver = "8.8.8.8"

  connection {
    type     = "ssh"
    user     = var.user_name
    password = var.user_password
    host     = self.ssh_host
    timeout  = "5m"
  }

  provisioner "remote-exec" {
    inline = [
      "echo '1. Triển khai cơ chế tự động phá khóa Apt...'",
      "echo '${var.user_password}' | sudo -S systemctl stop unattended-upgrades || true",
      "echo '${var.user_password}' | sudo -S systemctl disable unattended-upgrades || true",
      "echo '${var.user_password}' | sudo -S killall apt apt-get || true",
      "echo '${var.user_password}' | sudo -S rm -f /var/lib/apt/lists/lock /var/cache/apt/archives/lock /var/lib/dpkg/lock*",
      "echo '${var.user_password}' | sudo -S dpkg --configure -a",

      "echo '2. Đang cập nhật và cài đặt MySQL...'",
      "echo '${var.user_password}' | sudo -S sed -i \"s/[a-z]*.archive.ubuntu.com/vn.archive.ubuntu.com/g\" /etc/apt/sources.list",
      "echo '${var.user_password}' | sudo -S apt-get update -y > /dev/null",
      "echo '${var.user_password}' | sudo -S apt-get install -y mysql-server",

      "echo '3. Đang cài đặt và kích hoạt Tailscale...'",
      "curl -fsSL https://tailscale.com/install.sh | sh",
      "echo '${var.user_password}' | sudo -S tailscale up --authkey=${var.tailscale_auth_key} --hostname=${var.vm_name} --ssh",

      "echo '4. Đang cấu hình Database và quyền truy cập...'",
      "echo '${var.user_password}' | sudo -S systemctl enable --now mysql",
      "sleep 10",
      "echo '${var.user_password}' | sudo -S mysql -e \"CREATE DATABASE IF NOT EXISTS ${var.db_name};\"",
      "echo '${var.user_password}' | sudo -S mysql -e \"CREATE USER IF NOT EXISTS '${var.db_user}'@'%' IDENTIFIED BY '${var.db_password}';\"",
      "echo '${var.user_password}' | sudo -S mysql -e \"GRANT ALL PRIVILEGES ON ${var.db_name}.* TO '${var.db_user}'@'%';\"",
      "echo '${var.user_password}' | sudo -S mysql -e \"FLUSH PRIVILEGES;\"",
      "echo '=== THÀNH CÔNG: MYSQL ĐÃ TỰ ĐỘNG CÀI XONG! ==='",

      "echo '--- IP Tailscale cua ban la: ---'",
      "tailscale ip -4"
    ]
  }
}
