terraform {
  cloud {
    organization = "tonytechlab-group"
    workspaces {
      name = "hybrid-lab-dev"
    }
  }

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.66.1"
    }
  }
}

provider "proxmox" {
  endpoint  = var.proxmox_api_url_thong
  api_token = "${var.proxmox_api_token_id_thong}=${var.proxmox_api_token_secret_thong}"
  insecure  = true

  ssh {
    agent       = false
    username    = "terraform-user" # Thường là root để có quyền ghi vào /var/lib/vz/
    private_key = var.proxmox_ssh_private_key
  }
}
