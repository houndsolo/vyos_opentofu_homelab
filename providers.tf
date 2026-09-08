provider "vyoscmd" {
  alias = "leaves"
  for_each = {for name, node in var.fabric.nodes.leaves : name => node}
  endpoint = "https://${cidrhost(var.fabric.defaults.vyos_mgmt_prefix, each.value.id)}"
  api_key                  = var.vyos_key
  insecure_skip_tls_verify = true
}
