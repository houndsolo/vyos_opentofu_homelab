provider "vyoscmd" {
  endpoint                 = "https://10.20.11.11"
  api_key                  = var.vyos_key
  insecure_skip_tls_verify = true
}
