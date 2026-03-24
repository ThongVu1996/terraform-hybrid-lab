provider "proxmox" {
  # Provider sẽ tự động sử dụng các biến môi trường:
  # PM_API_URL
  # PM_API_TOKEN_ID
  # PM_API_TOKEN_SECRET
  # mà bạn đã cấu hình trên HCP Terraform UI.

  pm_tls_insecure = true
}
