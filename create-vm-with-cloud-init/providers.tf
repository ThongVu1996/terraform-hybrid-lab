terraform {
  cloud {
    organization = "tonytechlab-group"
    workspaces {
      name = "hybrid-lab-dev"
    }
  }

  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.2-rc07"
    }
  }
}

provider "proxmox" {
  pm_api_url          = var.proxmox_api_url_thong
  pm_api_token_id     = var.proxmox_api_token_id_thong
  pm_api_token_secret = var.proxmox_api_token_secret_thong
  pm_tls_insecure     = true
}
