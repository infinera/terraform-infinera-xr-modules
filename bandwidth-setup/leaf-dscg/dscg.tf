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
    dscgid     = each.value["leafdscgid"]
    usdscids = each.value["leafdscidlist"]
    dsdscids = each.value["leafdscidlist"]
}
