locals {
  vrf_commands = flatten([
    for vrf in local.role_vrfs : [
      "set vrf name ${vrf} table ${vrf.vrf_table}",
    ]
  ])
}
