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

  ipconfig0  = "ip=172.199.10.151/24,gw=172.199.10.1"
  nameserver = "8.8.8.8"

  # KHAI BÁO THÔNG TIN TRUY CẬP CƠ BẢN
  ciuser     = "thong"
  cipassword = var.ssh_password

  # ĐIỂM SÁNG GIÁ NHẤT: Trỏ cấu hình Cloud-init vào tệp Snippets vừa tạo ở Proxmox
  # "local" chính là tên ổ cứng storage mặc định lưu trữ file Snippets (có thể là local-lvm, tùy cài đặt Proxmox của bạn)
  cicustom = "user=local:snippets/db-setup.yaml"
}

