resource "vyoscmd_commands" "test" {
  name = "provider-test"
  commands = [
    "set interfaces dummy dum99 mtu 1450",
    "set interfaces dummy dum99 address 79.79.79.80/32",
    "set interfaces dummy dum99 address 79.79.79.81/32",
    "set interfaces dummy dum99 address 79.79.79.82/32",
  ]
}
