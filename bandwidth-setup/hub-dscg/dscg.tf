/*

 for each hub 
  create dscg

 for each leaf
  create dscg
*/
terraform {
  required_providers {
    xrcm = {
      source = "infinera.com/poc/xrcm"
    }
  }
  // required_version = "~> 1.1.3"
}

//Hub tx == ds; rx == us
//leaf tx == us; rx == ds

resource "xrcm_dscg" "dscg" {
  for_each = var.leafbandwidth
    n         = var.n
    portid    = var.portid
    carrierid = var.carrierid
    dscgid     = each.value["hubdscgid"]
    rxdscs = var.trafficmode == "L1Mode" ? each.value["hubdscidlist"] : each.value["direction"] == "us" ? each.value["hubdscidlist"] : []
    txdscs = var.trafficmode == "L1Mode" ? each.value["hubdscidlist"] : each.value["direction"] == "ds" ? each.value["hubdscidlist"] : []
    //add multiple condition to cover bidi - need to verify if following is correct
    //usdscids = each.value["direction"] == "us" ? each.value["direction"] == "bidi" ? each.value["leafdscidlist"] : ""
}