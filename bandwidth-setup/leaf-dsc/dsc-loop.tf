terraform {
  required_providers {
    xrcm = {
      source = "infinera.com/poc/xrcm"
    }
  }
  // required_version = "~> 1.1.3"
}

module "leaf-dsc" {
  source = "./leaf-dsc"

  for_each            = var.leafbandwidth
  n                   = var.n
  portid              = var.portid
  carrierid           = var.carrierid
  txenabled           = true
  rxenabled           = true
  leafdscids          = var.leafdscids
  constellationdscids = each.value["hubdscidlist"]

}
