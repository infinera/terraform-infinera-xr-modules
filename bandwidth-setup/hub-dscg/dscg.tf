terraform {
  required_providers {
    xrcm = {
      source = "infinera.com/poc/xrcm"
    }
  }
  // required_version = "~> 1.1.3"
}

resource "xrcm_dscg" "dscg" {
  for_each = var.leafbandwidth
    n         = var.n
    portid    = var.portid
    carrierid = var.carrierid
    dscgid     = each.value["hubdscgid"]
    usdscids = each.value["hubdscidlist"]
    dsdscids = each.value["hubdscidlist"]
}
