terraform {
  required_providers {
    xrcm = {
      source = "infinera.com/poc/xrcm"
    }
  }
  // required_version = "~> 1.1.3"
}

module "ethernet-prbs-diag" {
  source = "./ethernet-prbs-diag"
  
  for_each = toset(keys(var.ethernet-prbs-diag))
    n            = each.value
    ethernetids   = keys(var.ethernet-prbs-diag[each.value])
    ethernet-prbs-diag = var.ethernet-prbs-diag
}
