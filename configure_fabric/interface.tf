locals {
  interface_commands= concat(
    local.interface_base_commands,
    local.interface_router_advertisement_commands,
  )
  interface_base_commands = [
    flatten([
      for spine in var.fabric.nodes.spines : [
        "set interfaces ethernet eth${spine.id} description 'p2p-spine-${spine.id}'",
        "set interfaces ethernet eth${spine.id} hw-id '02:07:11:00:11:01'",
        "set interfaces ethernet eth${spine.id} mtu '${var.fabric.vxlan.outer_mtu}'",
      ]
    ])
    "set interfaces ethernet eth3 description 'link to vms'",
    #"set interfaces ethernet eth3 hw-id '02:07:11:00:11:03'",
    #"set interfaces ethernet eth3 mtu '${var.fabric.vxlan.mtu}'",
  ]
  interface_router_advertisement_commands = [
    "set service router-advert interface eth1",
    "set service router-advert interface eth2",
  ]
}
