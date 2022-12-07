terraform {
  required_providers {
    xrcm = {
      source = "infinera.com/poc/xrcm"
    }
  }
  // required_version = "~> 1.1.3"
}

resource "xrcm_lc" "lc" {

  for_each = var.lclist
  n        = var.n
  lcid     = each.key
  // TODO Port ID and Client ID
  //clientid  = each.value["clientid"]
  clientid  = var.trafficmode == "L2Mode" ? each.key : each.value["clientindex"]
  dscgid    = each.value["dscgid"]
  lctype    = each.value["lctype"]
  lineptpid = var.lineptpid
  carrierid = var.carrierid

}
