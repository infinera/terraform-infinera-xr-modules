
module "hub-dscg" {
  source     = "./hub-dscg"
  depends_on = [module.hub-dsc]
  // create DSCGs for each leaf
  for_each = toset(var.leaf_names)
  // Loop all the leafs defined, creating corresponding DSCGs in the hub
  leafbandwidth = var.leaf-2-hub-dscids[each.key]
  n             = var.hub_names[0]
  portid        = 1
  carrierid     = 1




}

module "leaf-dscg" {
  source = "./leaf-dscg"


  depends_on = [module.leaf-dsc]
  for_each   = toset(var.leaf_names)
  // Loop all the leafs defined

  /*Providers Note: converts the ids to list of AIDs
              usDSCs: ['XR-L1-C1-DSC5', 'XR-L1-C1-DSC7', 'XR-L1-C1-DSC9', 'XR-L1-C1-DSC11']
              dsDSCs: ['XR-L1-C1-DSC5', 'XR-L1-C1-DSC7', 'XR-L1-C1-DSC9', 'XR-L1-C1-DSC11']
  */


  leafbandwidth = var.leaf-2-hub-dscids[each.key]
  n             = each.key
  portid        = 1
  carrierid     = 1


}


