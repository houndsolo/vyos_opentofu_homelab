resource "vyoscmd_commands" "test" {
  name = "provider-test"
  commands = flatten([
    local.bgp_commands,
    local.vxlan_commands,
    local.vrf_commands,
    local.interface_commands,
    local.policy_commands,
  ])
}
