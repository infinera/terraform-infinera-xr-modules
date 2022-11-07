// Create on Hub 
//   Hub BW
module "hub-dscg" {

  source = "./hub-dscg"

  for_each = toset(var.hub_names)
  // Loop all the leafs defined, creating corresponding DSCGs in the hub
  leafbandwidth = var.hub_bandwidth[each.key]
  n             = each.key
  lineptpid     = 1
  carrierid     = 1
  trafficmode   = var.trafficmode
}

// Create on Hub 
//   Leaf BW
module "hub-dscg-leaf" {
  source = "./hub-dscg"

  // In case of L2 Mode, create leaf DSCGs in the Hub, L1 Mode, don't create
  for_each = var.trafficmode == "L2Mode" && length(var.hub_names) > 0 ? toset(var.leaf_names) : toset([])
  // Loop all the leafs defined, creating corresponding DSCGs in the hub
  leafbandwidth = var.leaf_bandwidth[each.key]
  n             = var.hub_names[0]
  lineptpid     = 1
  carrierid     = 1
  trafficmode   = var.trafficmode
}


// Create on Leaf
//  Leaf BW
module "leaf-dscg" {
  source = "./leaf-dscg"


  depends_on = [module.leaf-dsc]
  for_each   = toset(var.leaf_names)
  // Loop all the leafs defined

  /*Providers Note: converts the ids to list of AIDs
              usDSCs: ['XR-L1-C1-DSC5', 'XR-L1-C1-DSC7', 'XR-L1-C1-DSC9', 'XR-L1-C1-DSC11']
              dsDSCs: ['XR-L1-C1-DSC5', 'XR-L1-C1-DSC7', 'XR-L1-C1-DSC9', 'XR-L1-C1-DSC11']
  */

  leafbandwidth = var.leaf_bandwidth[each.key]
  n             = each.key
  lineptpid     = 1
  carrierid     = 1
  trafficmode   = var.trafficmode
}

// Create on Leaf
//  Hub Entry
module "leaf-dscg-hub" {
  source = "./leaf-dscg-hub"


  // In case of L2 Mode, create leaf DSCGs in the Hub, L1 Mode, don't create
  for_each = var.trafficmode == "L2Mode" ? toset(var.leaf_names) : toset([])
  //   for_each = toset(var.leaf_names)
  // Loop all the leafs defined

  /*Providers Note: converts the ids to list of AIDs
              usDSCs: ['XR-L1-C1-DSC5', 'XR-L1-C1-DSC7', 'XR-L1-C1-DSC9', 'XR-L1-C1-DSC11']
              dsDSCs: ['XR-L1-C1-DSC5', 'XR-L1-C1-DSC7', 'XR-L1-C1-DSC9', 'XR-L1-C1-DSC11']
  */


  leafbandwidth = var.leaf_bandwidth[each.key]
  n             = each.key
  lineptpid     = 1
  carrierid     = 1
  hubbandwidth  = length(var.hub_names) > 0 ? var.hub_bandwidth[var.hub_names[0]] : null

}
