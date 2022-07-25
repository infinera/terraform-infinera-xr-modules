terraform {
  required_providers {
    xrcm = {
      source = "infinera.com/poc/xrcm"
    }
  }
  // required_version = "~> 1.1.3"
}

resource "xrcm_dsc" "dsc" {
  // description = "Leaf DSC Resource, is precreated, constellationdscid is set to hubdscid for each leaf DSC"
  for_each = toset(var.leafdscids)
  // count = length(var.leafdscids)
    dscid     = each.value
    n         = var.n
    portid    = var.portid
    carrierid = var.carrierid
    // Local Leaf DSCID
    
    //dscaid = derived
    //usability         = var.usability // 
    txenabled          = var.txenabled
    rxenabled          = var.rxenabled
    // Hub DSC ID for this leaf DSC
    constellationdscid = var.constellationdscids[tonumber(each.value) -1 ]
  //facprbsgenenabled = var.facprbsgenenabled
  //facprbsmonenabled = var.facprbsmonenabled
  //poweroffset       = var.poweroffset
}
