
/*
module "hub-port" {
  source = "./port"

  operstatus = "disabled"

  providers = {
    xrcm = xrcm.xrcm
  }
}
*/




module "hub-dsc" {
  source = "./hub-dsc"
  
  
  

  for_each = toset(var.hub_names)
 // for_each  = toset(var.hubdscids)
    dscids    = var.hubdscids
    // dscid     = each.value
    n         = each.value
    portid    = 1
    carrierid = 1
    txenabled = true
    rxenabled = true


}



module "leaf-dsc" {
  source = "./leaf-dsc"

  
  for_each = toset( var.leaf_names)
    n     = each.value
  
    portid              = 1
    carrierid           = 1
    txenabled           = true
    rxenabled           = true
    leafdscids          = var.leafdscids
    leafbandwidth = var.leaf-2-hub-dscids[each.key]

}

/*


module "leafs-port" {
  source = "./port"

  depends_on = [module.hub-cfg[0]]

  count      = length(var.leaf_names)
  n          = var.leaf_names[count.index]
  operstatus = "disabled"
  providers = {
    xrcm = xrcm.xrcm
  }
}

module "huf-port-dscg" {
  source = "./dscg"

  depends_on = [module.hub-cfg[0]]

  n      = "XR-SFO-1"
  usdscs = ["aa", "bb"]
  dsdscs = ["cc", "dd"]
  providers = {
    xrcm = xrcm.xrcm
  }
}

module "leafs-port-dscg" {
  source = "./dscg"

  depends_on = [module.hub-cfg[0]]

  count  = length(var.leaf_names)
  n      = var.leaf_names[count.index]
  usdscs = ["e", "f"]
  dsdscs = ["g", "h"]

  providers = {
    xrcm = xrcm.xrcm
  }
}
*/

/* hub1 - dsc1 ID = 1
   hub1 - dsc2 ID = 2 
  ...
   hub1 - dsc16 ID = 16

   hub - dsc lookup [ { leafName: string ,
                        constellationdscids: [] } ]
   ----
   leaf1 dsc1 constellationdscid =  5
   leaf1 dsc2 constellationdscid =  1
   leaf1 dsc3 constellationdscid =  7
   leaf1 dsc4 constellationdscid =  3
   ---
   leaf2 dsc1 constellationdscid =  9
   leaf2 dsc2 constellationdscid =  11
   leaf2 dsc3 constellationdscid =  13
   leaf2 dsc4 constellationdscid =  15
   ----
   leaf3 dsc1 constellationdscid =  2
   leaf3 dsc2 constellationdscid =  4
   leaf3 dsc3 constellationdscid =  6
   leaf3 dsc4 constellationdscid =  8
   ----
   leaf4 dsc1 constellationdscid =  10
   leaf4 dsc2 constellationdscid =  12
   leaf4 dsc3 constellationdscid =  14
   leaf4 dsc4 constellationdscid =  16
*/
