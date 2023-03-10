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
  for_each  = var.leafbandwidth
  n         = var.n
  lineptpid = var.lineptpid
  carrierid = var.carrierid
  dscgid   = each.value["leafdscgid"]
  txcdscs   = var.trafficmode == "L1Mode" ? each.value["leafdscidlist"] : each.value["direction"] == "us" ? each.value["leafdscidlist"] : []
  rxcdscs   = var.trafficmode == "L1Mode" ? each.value["leafdscidlist"] : each.value["direction"] == "ds" ? each.value["leafdscidlist"] : []
  //add multiple condition to cover bidi - need to verify if following is correct
  // usdscids = each.value[direction] == "us" ? each.value[direction] == "bidi" ? each.value["leafdscidlist"] : ""
}


