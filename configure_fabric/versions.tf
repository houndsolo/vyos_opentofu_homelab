terraform {
  required_version = ">= 1.9.0"
  required_providers {
    vyoscmd = {
      source = "registry.terraform.io/houndsolo/vyoscmd"
    }
  }
}
