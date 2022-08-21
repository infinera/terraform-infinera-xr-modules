terraform {
  required_providers {
    xrcm = {
      source = "infinera.com/poc/xrcm"
    }
  }
  // required_version = "~> 1.1.3"
}

resource "xrcm_ethernet_diag" "ethernet_diag" {

  for_each = toset(var.ethernetids)
    n            = var.n
    ethernetid   = each.value
    loopbackmode = var.ethernet-loopback-diag[var.n][each.value]["loopbackmode"]
    loopbacktype = var.ethernet-loopback-diag[var.n][each.value]["loopbacktype"]
}