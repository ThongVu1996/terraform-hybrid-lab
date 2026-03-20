# 1. Dò tìm máy ảo mẫu (Template)
data "proxmox_virtual_environment_vms" "ubuntu_template" {
  node_name = var.proxmox_node_thong
  filter {
    name   = "name"
    values = [var.proxmox_template_name]
  }
}

# 2. Tạo file Cloud-init Snippet tự động
resource "proxmox_virtual_environment_file" "mysql_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.proxmox_node_thong
  count        = var.vm_instance_count

  source_raw {
    file_name = "mysql-init-${var.db_name_thong}.yml"
    data      = <<-EOF
      #cloud-config
      ssh_fp_console: false
      output: { all: ">> /dev/ttyS0" }

      users:
        - name: thong
          groups: sudo
          shell: /bin/bash
          sudo: ALL=(ALL) NOPASSWD:ALL
          lock_passwd: false
          password: "${var.ssh_password}"

      # Đảm bảo có CURL để cài Tailscale
      packages:
        - mysql-server
        - curl

      runcmd:
        # 0. Chờ giải phóng APT Lock (Quan trọng nhất để không bị lỗi 'tailscale not found')
        - [ sh, -c, "echo '--- [0/5] Doi giai phong apt lock... ---' > /dev/ttyS0" ]
        - [ sh, -c, "while fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do sleep 5; done;" ]

        - [ sh, -c, "echo '--- [1/5] Kiem tra mang... ---' > /dev/ttyS0" ]
        - [ sh, -c, "ping -c 3 8.8.8.8 > /dev/ttyS0 2>&1" ]

        - [ sh, -c, "echo '--- [2/5] Cap nhat Repo & Cai Tailscale... ---' > /dev/ttyS0" ]
        - sed -i "s/[a-z]*.archive.ubuntu.com/vn.archive.ubuntu.com/g" /etc/apt/sources.list
        - apt-get update -y
        # Xoá trạng thái tailscale nếu nhỡ đã tồn tại
        - [ sh, -c, "rm -rf /var/lib/tailscale/tailscaled.state" ]
        # Cài đặt tailscal
        - [ sh, -c, "curl -fsSL https://tailscale.com/install.sh | sh > /dev/ttyS0 2>&1" ]
        - [ sh, -c, "echo '--- [3/5] Kick hoat Tailscale... ---' > /dev/ttyS0" ]
        # Thêm --accept-dns=true để nhận diện được MagicDNS của các máy khác
        - [ sh, -c, "tailscale up --authkey=${var.tailscale_auth_key} --hostname=db-server  --ssh --accept-dns=true > /dev/ttyS0 2>&1" ]

        - [ sh, -c, "echo '--- [4/5] Cau hinh MySQL & Cho phep Remote... ---' > /dev/ttyS0" ]
        - systemctl enable --now mysql
        - sleep 5
        # Mở Bind Address để MySQL lắng nghe trên card mạng Tailscale (0.0.0.0)
        - [ sh, -c, "sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/mysql.conf.d/mysqld.cnf" ]
        - systemctl restart mysql
        
        # Tạo DB, User và Phân quyền
        - mysql -e "CREATE DATABASE IF NOT EXISTS ${var.db_name_thong};"
        # Chỉ cho phép User kết nối từ dải IP Tailscale (100.x.x.x) để tăng bảo mật
        - mysql -e "CREATE USER IF NOT EXISTS '${var.db_user_thong}'@'100.%' IDENTIFIED BY '${var.db_password_thong}';"
        - mysql -e "GRANT ALL PRIVILEGES ON ${var.db_name_thong}.* TO '${var.db_user_thong}'@'100.%';"
        - mysql -e "FLUSH PRIVILEGES;"

        - [ sh, -c, "echo '=== SETUP COMPLETED SUCCESSFULLY ===' > /dev/ttyS0" ]
    EOF
  }
}

# 3. Khởi tạo Máy ảo
resource "proxmox_virtual_environment_vm" "mysql_node" {
  name      = "vm-mysql-lab-thong"
  node_name = var.proxmox_node_thong
  count     = var.vm_instance_count

  clone {
    vm_id = data.proxmox_virtual_environment_vms.ubuntu_template.vms[0].vm_id
  }

  # Hiển thị log qua Console Proxmox
  serial_device {}
  vga { type = "serial0" }

  initialization {
    ip_config {
      ipv4 {
        address = "172.199.10.150/24"
        gateway = "172.199.10.1"
      }
    }
    dns {
      servers = ["8.8.8.8", "1.1.1.1"]
    }
    user_data_file_id = proxmox_virtual_environment_file.mysql_config[count.index].id
  }

  cpu { cores = 2 }
  memory { dedicated = 4096 }
  network_device { bridge = "vmbr0" }
}
