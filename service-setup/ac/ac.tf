terraform {
  required_providers {
    xrcm = {
      source = "infinera.com/poc/xrcm"
    }
  }
  // required_version = "~> 1.1.3"
}

resource "xrcm_ac" "ac" {

  for_each = var.aclist
    n        = var.n
    ethernetid = each.value["clientid"]
    acid     = each.key
    capacity     = each.value["rate"]
    imc      = each.value["imc"]
    imc_outer_vid = each.value["imc_outer_vid"]
    emc      = each.value["emc"]
    emc_outer_vid = each.value["emc_outer_vid"]
}
