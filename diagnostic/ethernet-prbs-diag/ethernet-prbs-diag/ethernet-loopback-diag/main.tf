terraform {
  required_providers {
    xrcm = {
      source = "infinera.com/poc/xrcm"
    }
  }
  // required_version = "~> 1.1.3"
}

module "ethernet-loopback-diag" {
  source = "./ethernet-loopback-diag"
  
  for_each = toset(keys(var.ethernet-loopback-diag))
    n            = each.value
    ethernetids   = keys(var.ethernet-loopback-diag[each.value])
    ethernet-loopback-diag = var.ethernet-loopback-diag
}
