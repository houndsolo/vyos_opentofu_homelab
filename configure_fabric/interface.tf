locals {
  interface_commands= concat(
    local.interface_base_commands,
    local.interface_mac_commands,
    local.interface_router_advertisement_commands,
    local.interface_external_commands,
  )
  interface_mac_commands = [
    flatten([
      for interface, mac in var.node.fabric_macs: [
        "set interfaces ethernet ${interface} hw-id '${mac}'"
      ]
    ])
  ]
  interface_base_commands = [
    flatten([
      for spine in var.fabric.nodes.spines : [
        "set interfaces ethernet eth${spine.id} description 'p2p-spine-${spine.id}'",
        "set interfaces ethernet eth${spine.id} mtu '${var.fabric.vxlan.outer_mtu}'",
      ]
    ])
  ]
  interface_router_advertisement_commands = [
    "set service router-advert interface eth1",
    "set service router-advert interface eth2",
  ]
  interface_external_commands = [
    "set interfaces ethernet eth3 description 'link to vms'",
    "set interfaces ethernet eth3 mtu '${var.fabric.vxlan.mtu}'",
  ]
}
