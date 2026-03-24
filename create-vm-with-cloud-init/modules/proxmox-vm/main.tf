terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = ">= 3.0.2-rc07"
    }
  }
}

resource "proxmox_vm_qemu" "vm" {
  name        = var.vm_name
  target_node = var.node_name

  clone      = var.template_name
  full_clone = true
  agent      = 1
  os_type    = "cloud-init"

  cpu {
    cores   = var.cores
    sockets = 1
  }
  memory = var.memory
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

  ipconfig0  = "ip=${var.ip_address},gw=${var.gateway}"
  nameserver = "8.8.8.8"

  ciuser     = var.ssh_user
  cipassword = var.ssh_password

  cicustom = "user=${var.cloud_init_snippet}"
}
