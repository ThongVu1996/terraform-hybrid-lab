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
    tailscale = {
      source  = "tailscale/tailscale"
      version = "~> 0.17"
    }
  }
}

# Cấu hình Provider cho Proxmox
provider "proxmox" {
  endpoint  = var.proxmox_api_url_thong
  api_token = "${var.proxmox_api_token_id_thong}=${var.proxmox_api_token_secret_thong}"
  insecure  = true

  ssh {
    agent       = false
    username    = "terraform-user"
    private_key = var.proxmox_ssh_private_key
  }
}

# Cấu hình Provider cho Tailscale
provider "tailscale" {
  oauth_client_id     = var.ts_oauth_client_id
  oauth_client_secret = var.ts_oauth_client_secret
  tailnet             = "anhthongvu1996@gmail.com"
}

