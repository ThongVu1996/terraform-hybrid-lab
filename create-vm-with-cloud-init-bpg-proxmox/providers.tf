# Cấu hình Provider cho Proxmox (Thông tin xác thực lấy từ Environment Variables trên HCP)
provider "proxmox" {
  insecure  = true

  ssh {
    agent       = false
    username    = "terraform-user"
    private_key = var.proxmox_ssh_private_key
  }
}

# Cấu hình Provider cho Tailscale (Thông tin xác thực lấy từ Environment Variables trên HCP)
provider "tailscale" {
}

