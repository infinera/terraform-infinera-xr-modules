terraform {
  required_providers {
    xrcm = {
      source = "infinera.com/poc/xrcm"
    }
  }
  // required_version = "~> 1.1.3"
}

locals {
    hub_diag-tests = {for k1,v1 in var.hub-leaf-carrier-diag : k1 => values(v1)[0]["loopback"] if values(v1)[0]["at"] == "hubend" || values(v1)[0]["at"] == "bothends"}
    leaf_diag-tests = { for k1,v1 in var.hub-leaf-carrier-diag : k1 => values(v1)[0]["loopback"] if values(v1)[0]["at"] == "leafend" || values(v1)[0]["at"] == "bothends" }
  }


resource "xrcm_carrier_diag" "hub_carrier_diag" {

  for_each = toset(keys(local.hub_diag-tests))
      n         = var.hub_names[0]
      portid    = 1
      carrierid = 1
      loopback = local.hub_diag-tests[each.value]
}

resource "xrcm_carrier_diag" "leaf_carrier_diag" {

    for_each = toset(keys(local.leaf_diag-tests))
      n         = each.value
      portid    = 1
      carrierid = 1
      loopback = local.leaf_diag-tests[each.value]
}
