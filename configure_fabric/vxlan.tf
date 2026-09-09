locals {
  vxlan_commands = concat(
    local.vxlan_base_commands,
    local.bridge_base_commands,
    local.vni_commands,
    local.l2_vni_commands,
  )
  bridge_base_commands = [
  "set interfaces bridge br0 enable-vlan",
  "set interfaces bridge br0 ip enable-arp-accept",
  "set interfaces bridge br0 mac '00:13:37:00:00:${var.node.id}'",
  "set interfaces bridge br0 member interface vxlan0 disable-learning",
  "set interfaces bridge br0 mtu '${var.fabric.vxlan.outer_mtu}'",
  ]
  vxlan_base_commands = [
  "set interfaces vxlan vxlan0 ipv6",
  "set interfaces vxlan vxlan0 mac '00:13:37:00:00:${var.node.id}'",
  "set interfaces vxlan vxlan0 mtu '${var.fabric.vxlan.mtu}'",
  "set interfaces vxlan vxlan0 parameters external",
  "set interfaces vxlan vxlan0 parameters nolearning",
  "set interfaces vxlan vxlan0 parameters vni-filter",
  "set interfaces vxlan vxlan0 source-address '${cidrsubnet(var.fabric.defaults.ipv6_fabric_loopback_prefix,64,parseint(tostring(var.node.id),16))}'",
  ]
  vni_commands = flatten([
    for vni in local.all_vnis : [
  "set interfaces vxlan vxlan0 vlan-to-vni ${vni.vlan_id} vni '${vni.vni}'",
  "set interfaces bridge br0 vif ${vni.vlan_id} mtu '${var.fabric.vxlan.outer_mtu}'",
  "set interfaces bridge br0 vif ${vni.vlan_id} vrf '${vni.vrf}'",
    ]
  ])

  l2_vni_commands = [
    flatten([
      for vni in local.l2vnis : [
        "set interfaces bridge br0 member interface eth3 allowed-vlan '${vni.vlan_id}'",
      ]
    ])
  ]
}
