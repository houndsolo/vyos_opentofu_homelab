module "create_leaf_vms" {
  for_each = { for name, leaf in var.fabric.nodes.leaves : name => merge(leaf, { hostname = "vtep-${name}" }) if leaf.is_vm && leaf.role == "pve" && leaf.proxmox_target == "pve" }
  source   = "./pve_vm"
  host_node = merge(each.value, {
    network_devices = [for index, bridge in coalesce(each.value.underlay_bridges, var.proxmox_vtep_vm.default_underlay_bridges) : {
      bridge      = bridge
      mac_address = each.value.fabric_macs["eth${index + 1}"]
    }]
  })
  vm_config       = var.proxmox_vtep_vm
  fabric_defaults = var.fabric.defaults
}

module "create_border_leaf_vms" {
  for_each = { for name, leaf in var.fabric.nodes.leaves : name => merge(leaf, { hostname = "vtep-border-${leaf.id}" }) if leaf.is_vm && leaf.role == "external_l3" && leaf.proxmox_target == "pve" }
  source   = "./pve_vm"
  host_node = merge(each.value, {
    network_devices = [for index, bridge in coalesce(each.value.underlay_bridges, var.proxmox_vtep_vm.default_underlay_bridges) : {
      bridge      = bridge
      mac_address = each.value.fabric_macs["eth${index + 1}"]
    }]
  })
  vm_config       = var.proxmox_vtep_vm
  fabric_defaults = var.fabric.defaults
}

module "create_fabric_ext_leaf_vms" {
  for_each = { for name, leaf in var.fabric.nodes.leaves : name => merge(leaf, { hostname = "vtep-fabric-ext-${leaf.id}" }) if leaf.is_vm && leaf.role == "external_l2" && leaf.proxmox_target == "pve" }
  source   = "./pve_vm"
  host_node = merge(each.value, {
    network_devices = [for index, bridge in coalesce(each.value.underlay_bridges, var.proxmox_vtep_vm.default_underlay_bridges) : {
      bridge      = bridge
      mac_address = each.value.fabric_macs["eth${index + 1}"]
    }]
  })
  vm_config       = var.proxmox_vtep_vm
  fabric_defaults = var.fabric.defaults
}

module "create_greatfox_leaf_vms" {
  for_each = { for name, leaf in var.fabric.nodes.leaves : name => merge(leaf, { hostname = "vtep-${name}" }) if leaf.is_vm && leaf.role == "pve" && leaf.proxmox_target == "greatfox" }
  source   = "./pve_vm"
  host_node = merge(each.value, {
    network_devices = [for index, bridge in coalesce(each.value.underlay_bridges, var.proxmox_vtep_vm.default_underlay_bridges) : {
      bridge      = bridge
      mac_address = each.value.fabric_macs["eth${index + 1}"]
    }]
  })
  vm_config       = var.proxmox_vtep_vm
  fabric_defaults = var.fabric.defaults

  providers = { proxmox = proxmox.greatfox }
}

