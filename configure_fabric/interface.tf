locals {
  interface_commands= concat(
    local.interface_base_commands,
    local.interface_vxlan_commands,
    local.interface_bridge_commands,
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
    #"set interfaces ethernet eth3 description 'link to vms'",
    #"set interfaces ethernet eth3 hw-id '02:07:11:00:11:03'",
    #"set interfaces ethernet eth3 mtu '${var.fabric.vxlan.mtu}'",
  ]
  interface_vxlan_commands = [
    "set interfaces vxlan vxlan0 ip",
    "set interfaces vxlan vxlan0 ipv6",
    "set interfaces vxlan vxlan0 mac '00:13:37:00:00:11'",
    "set interfaces vxlan vxlan0 mtu '9119'",
    "set interfaces vxlan vxlan0 parameters external",
    "set interfaces vxlan vxlan0 parameters nolearning",
    "set interfaces vxlan vxlan0 parameters vni-filter",
    "set interfaces vxlan vxlan0 source-address 'fd69:255:240::11'",
    "set interfaces vxlan vxlan0 vlan-to-vni 2 vni '9002'",
    "set interfaces vxlan vxlan0 vlan-to-vni 6 vni '9006'",
    "set interfaces vxlan vxlan0 vlan-to-vni 8 vni '9008'",
    "set interfaces vxlan vxlan0 vlan-to-vni 9 vni '9009'",
    "set interfaces vxlan vxlan0 vlan-to-vni 10 vni '9010'",
    "set interfaces vxlan vxlan0 vlan-to-vni 11 vni '9011'",
    "set interfaces vxlan vxlan0 vlan-to-vni 62 vni '6200'",
    "set interfaces vxlan vxlan0 vlan-to-vni 66 vni '6600'",
    "set interfaces vxlan vxlan0 vlan-to-vni 69 vni '6900'",
  ]
  interface_router_advertisement_commands = [
    "set service router-advert interface eth1",
    "set service router-advert interface eth2",
  ]
  interface_bridge_commands = [
    "set interfaces bridge br0 enable-vlan",
    "set interfaces bridge br0 ip enable-arp-accept",
    "set interfaces bridge br0 mac '00:13:37:00:00:11'",
    "set interfaces bridge br0 member interface eth3 allowed-vlan '2'",
    "set interfaces bridge br0 member interface eth3 allowed-vlan '6'",
    "set interfaces bridge br0 member interface eth3 allowed-vlan '8'",
    "set interfaces bridge br0 member interface eth3 allowed-vlan '9'",
    "set interfaces bridge br0 member interface eth3 allowed-vlan '10'",
    "set interfaces bridge br0 member interface eth3 allowed-vlan '11'",
    "set interfaces bridge br0 member interface vxlan0 disable-learning",
    "set interfaces bridge br0 mtu '9189'",
    "set interfaces bridge br0 vif 2 mtu '9189'",
    "set interfaces bridge br0 vif 2 vrf 'lylat_infra'",
    "set interfaces bridge br0 vif 6 mtu '9189'",
    "set interfaces bridge br0 vif 6 vrf 'lylat_service'",
    "set interfaces bridge br0 vif 8 mtu '9189'",
    "set interfaces bridge br0 vif 8 vrf 'lylat_service'",
    "set interfaces bridge br0 vif 9 mtu '9189'",
    "set interfaces bridge br0 vif 9 vrf 'lylat_lan'",
    "set interfaces bridge br0 vif 10 mtu '9189'",
    "set interfaces bridge br0 vif 10 vrf 'lylat_lan'",
    "set interfaces bridge br0 vif 11 mtu '9189'",
    "set interfaces bridge br0 vif 11 vrf 'lylat_lan'",
    "set interfaces bridge br0 vif 62 mtu '9189'",
    "set interfaces bridge br0 vif 62 vrf 'lylat_infra'",
    "set interfaces bridge br0 vif 66 mtu '9189'",
    "set interfaces bridge br0 vif 66 vrf 'lylat_service'",
    "set interfaces bridge br0 vif 69 mtu '9189'",
    "set interfaces bridge br0 vif 69 vrf 'lylat_lan'",
  ]
}
