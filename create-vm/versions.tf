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
