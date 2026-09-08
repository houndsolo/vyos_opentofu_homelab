locals {
  router_id = cidrhost(var.fabric.defaults.ipv4_fabric_loopback_prefix, var.node.id)
  bgp_commands = concat(
    local.bgp_base_commands,
    local.bgp_evpn_commands,
    local.bgp_neighbor_commands,
    local.bgp_spine_overlay_commands,
    local.bgp_spine_underlay_commands,
  )
  bgp_base_commands = [
    "set protocols bgp system-as ${var.fabric.defaults.bgp_system_as}",
    "set protocols bgp parameters router-id ${local.router_id}",
    "set protocols bgp address-family ipv6-unicast network ${cidrsubnet(var.fabric.defaults.ipv6_fabric_loopback_prefix,64,parseint(tostring(var.node.id),16))}",
    "set protocols bgp address-family l2vpn-evpn advertise-all-vni",
    "set protocols bgp address-family l2vpn-evpn flooding head-end-replication",
    "set protocols bgp parameters bestpath as-path multipath-relax",
    "set protocols bgp parameters fast-convergence",
  ]
  bgp_evpn_commands = [
    for vni_id, l2vni in local.l2vnis :
    "set protocols bgp address-family l2vpn-evpn vni ${vni_id} rd '${local.router_id}:${vni_id}'"
  ]

  bgp_neighbor_commands = flatten([
    for name, spine in var.fabric.nodes.spines : [
      "set protocols bgp neighbor ${cidrhost(var.fabric.defaults.ipv6_fabric_loopback_prefix,parseint(tostring(spine.id),16))} peer-group 'spine_overlay'",
      "set protocols bgp neighbor ${spine.uplink_if} interface v6only peer-group 'spine_underlay'",
    ]
  ])

  bgp_spine_overlay_commands = [
    #    "set protocols bgp peer-group spine_overlay address-family l2vpn-evpn route-map export 'RM-EVPN-SPINE-EXPORT'",
    "set protocols bgp peer-group spine_overlay address-family l2vpn-evpn soft-reconfiguration inbound",
    "set protocols bgp peer-group spine_overlay bfd",
    "set protocols bgp peer-group spine_overlay remote-as 'internal'",
    "set protocols bgp peer-group spine_overlay update-source 'dum240'",
  ]
  bgp_spine_underlay_commands = [
    #"set protocols bgp peer-group spine_underlay address-family ipv6-unicast route-map export 'local_as_rm'",
    "set protocols bgp peer-group spine_underlay address-family ipv6-unicast soft-reconfiguration inbound",
    "set protocols bgp peer-group spine_underlay bfd",
    "set protocols bgp peer-group spine_underlay capability extended-nexthop",
    "set protocols bgp peer-group spine_underlay local-as ${var.fabric.defaults.bgp_system_as + var.node.id} no-prepend replace-as",
    "set protocols bgp peer-group spine_underlay remote-as 'external'",
  ]
}
