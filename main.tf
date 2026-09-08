module "pve_leaves_vms" {
  for_each  = { for name, node in var.fabric.nodes.leaves : name => node }
  source = "./configure_fabric"
  providers = { vyoscmd = vyoscmd.leaves[each.key] }
  node      = var.fabric.nodes.leaves[each.key]
  fabric      = var.fabric
  vnis        = var.vnis
  external_l3 = var.external_l3
  external_l2 = var.external_l2
}

module "create_fabric_vms" {
  source = "./create_fabric_vms"

  fabric           = local.fabric
  dhcp             = var.dhcp
  dhcp_attachments = local.dhcp_attachments
  pve_api_token    = var.pve_api_token
  gf_api_token     = var.gf_api_token
  proxmox_vtep_vm  = var.proxmox_vtep_vm
}

locals {
  vnis = {
    l3 = { for vni in var.vnis : tostring(vni.vni) => vni }
  }

  fabric = merge(var.fabric, {
    nodes = merge(var.fabric.nodes, {
      leaves = {
        for name, node in var.fabric.nodes.leaves : name => merge(node, {
          fabric_macs = {
            for interface_number in range(1, 4) :
            "eth${interface_number}" => join(":", regexall("..", format(
              "02%04d%04d%02d",
              var.fabric.defaults.underlay_local_as_base + node.id,
              node.id,
              interface_number,
            )))
          }
        })
      }
    })
  })
}
