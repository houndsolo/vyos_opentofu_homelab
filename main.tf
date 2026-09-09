module "pve_leaves_vms" {
  for_each  = var.fabric.nodes.leaves
  source = "./configure_fabric"
  providers = { vyoscmd = vyoscmd.leaves[each.key] }
  node = local.fabric.nodes.leaves[each.key]
  fabric      = var.fabric
  vnis        = var.vnis
  external_l3 = var.external_l3
  external_l2 = var.external_l2
}

module "create_fabric_vms" {
  source = "./create_fabric_vms"

  fabric           = local.fabric
  pve_api_token    = var.pve_api_token
  gf_api_token     = var.gf_api_token
  proxmox_vtep_vm  = var.proxmox_vtep_vm
}

locals {
  fabric = merge(var.fabric, {
    nodes = merge(var.fabric.nodes, {
      leaves = {
        for name, node in var.fabric.nodes.leaves : name => merge(node, {
          fabric_macs = {
            for i in range(1, 4) :
            "eth${i}" => format("bc:24:11:%02d:00:%02d", node.id, i)
          }
        })
      }
    })
  })
}
