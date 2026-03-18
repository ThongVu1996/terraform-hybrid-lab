resource "proxmox_vm_qemu" "mysql_node" {
  name        = "vm-mysql-thong"
  target_node = var.proxmox_node_thong

  clone      = "ubuntu-template"
  full_clone = true
  agent      = 1
  os_type    = "cloud-init"

  cpu {
    cores   = 2
    sockets = 1
  }
  memory = 4096
  scsihw = "virtio-scsi-pci"
  boot   = "order=scsi0;net0"

  disk {
    slot    = "ide2"
    type    = "cloudinit"
    storage = "local-lvm"
  }

  disk {
    slot    = "scsi0"
    size    = "32G"
    type    = "disk"
    storage = "local-lvm"
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0  = "ip=172.199.10.150/24,gw=172.199.10.1"
  nameserver = "8.8.8.8"

  connection {
    type     = "ssh"
    user     = "thong"
    password = var.ssh_password
    host     = self.ssh_host
    timeout  = "5m"
  }

  provisioner "remote-exec" {
    inline = [
      "echo '1. Triển khai cơ chế tự động phá khóa Apt...'",
      "echo '${var.ssh_password}' | sudo -S systemctl stop unattended-upgrades || true",
      "echo '${var.ssh_password}' | sudo -S systemctl disable unattended-upgrades || true",
      "echo '${var.ssh_password}' | sudo -S killall apt apt-get || true",
      "echo '${var.ssh_password}' | sudo -S rm -f /var/lib/apt/lists/lock /var/cache/apt/archives/lock /var/lib/dpkg/lock*",
      "echo '${var.ssh_password}' | sudo -S dpkg --configure -a",

      "echo '2. Đang cập nhật và cài đặt MySQL...'",
      "echo '${var.ssh_password}' | sudo -S sed -i \"s/[a-z]*.archive.ubuntu.com/vn.archive.ubuntu.com/g\" /etc/apt/sources.list",
      "echo '${var.ssh_password}' | sudo -S apt-get update -y > /dev/null",
      "echo '${var.ssh_password}' | sudo -S apt-get install -y mysql-server",

      "echo '${var.ssh_password}' | sudo -S apt-get install -y curl mysql-server",
      "echo '3. Đang cài đặt và kích hoạt Tailscale...'",
      # Tải và chạy script cài đặt chính thức của Tailscale
      "curl -fsSL https://tailscale.com/install.sh | sh",
      # Kích hoạt Tailscale với Auth Key, đặt hostname và bật tính năng SSH
      "echo '${var.ssh_password}' | sudo -S tailscale up --authkey=${var.tailscale_auth_key} --hostname=mysql-lab-provisioner --ssh",

      "echo '4. Đang cấu hình Database và quyền truy cập...'",
      "echo '${var.ssh_password}' | sudo -S systemctl enable --now mysql",
      "sleep 10",
      "echo '${var.ssh_password}' | sudo -S mysql -e \"CREATE DATABASE IF NOT EXISTS ${var.db_name_thong};\"",
      "echo '${var.ssh_password}' | sudo -S mysql -e \"CREATE USER IF NOT EXISTS '${var.db_user_thong}'@'%' IDENTIFIED BY '${var.db_password_thong}';\"",
      "echo '${var.ssh_password}' | sudo -S mysql -e \"GRANT ALL PRIVILEGES ON ${var.db_name_thong}.* TO '${var.db_user_thong}'@'%';\"",
      "echo '${var.ssh_password}' | sudo -S mysql -e \"FLUSH PRIVILEGES;\"",
      "echo '=== THÀNH CÔNG: MYSQL ĐÃ TỰ ĐỘNG CÀI XONG! ==='",

      "echo '--- IP Tailscale cua ban la: ---'",
      "tailscale ip -4"
    ]
  }
}
