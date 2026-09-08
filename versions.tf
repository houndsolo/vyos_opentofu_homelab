terraform {
  required_version = ">= 1.9.0"
  required_providers {
    vyoscmd = {
      source = "registry.terraform.io/houndsolo/vyoscmd"
    }
    proxmox = {
      source  = "local/mechanic/proxmox"
      version = "0.108.0"
    }
  }
}
