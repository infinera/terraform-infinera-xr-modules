terraform {
  required_providers {
    xrcm = {
      source = "infinera.com/poc/xrcm"
    }
  }
  // required_version = "~> 1.1.3"
}

resource "xrcm_dsc" "dsc" {
  for_each  = toset(var.dscidlist)
  n         = var.n
  lineptpid = var.lineptpid
  carrierid = var.carrierid
  dscid     = each.key
  //usability         = var.usability // 
  constellationdscid = length(var.constellationdscidlist) > 0 ? var.constellationdscidlist[each.key - 1] : 0
  txenabled          = length(var.constellationdscidlist) > 0 ? (contains(var.tx_bandwithlist, var.constellationdscidlist[each.key - 1])) ? true : false : false
  rxenabled          = length(var.constellationdscidlist) > 0 ? (contains(var.rx_bandwithlist, var.constellationdscidlist[each.key - 1])) ? true : false : false

  //facprbsgenenabled = var.facprbsgenenabled
  //facprbsmonenabled = var.facprbsmonenabled
  //poweroffset       = var.poweroffset
}

/*
resource "xrcm_dsc" "dsc" {
  for_each  = var.dsc_setting
  n         = var.n
  lineptpid    = var.lineptpid
  carrierid = var.carrierid
  dscid     = each.key
  //usability         = var.usability // 
  constellationdscid = each.value["constellationdscid"]
  txenabled          = each.value["tx"]
  rxenabled          = each.value["rx"]

  //facprbsgenenabled = var.facprbsgenenabled
  //facprbsmonenabled = var.facprbsmonenabled
  //poweroffset       = var.poweroffset
}
*/
