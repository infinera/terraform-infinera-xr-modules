terraform {
  required_providers {
    xrcm = {
      source = "infinera.com/poc/xrcm"
    }
  }
  // required_version = "~> 1.1.3"
}

resource "xrcm_dscg" "dscg" {
  for_each  = var.leafbandwidth
  n         = var.n
  lineptpid = var.lineptpid
  carrierid = var.carrierid
  dscgid    = each.value["leafdscgid"]
  /*usdscids  = var.trafficmode == "L1Mode" ? each.value["leafdscidlist"] : each.value["direction"] == "us" ? each.value["leafdscidlist"] : []
  dsdscids  = var.trafficmode == "L1Mode" ? each.value["leafdscidlist"] : each.value["direction"] == "ds" ? each.value["leafdscidlist"] : []
  //add multiple condition to cover bidi - need to verify if following is correct
  // usdscids = each.value[direction] == "us" ? each.value[direction] == "bidi" ? each.value["leafdscidlist"] : ""
  */
  rxdscs  = var.trafficmode == "L1Mode" ? each.value["leafdscidlist"] : []
  txdscs  = var.trafficmode == "L1Mode" ? each.value["leafdscidlist"] : []
}

