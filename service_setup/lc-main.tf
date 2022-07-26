/* Configuring Hub and Leaf modules
*/


// Hub
module "lc-hub" {
  source = "./lc"
 
  for_each   = toset(var.hub_names)
   n          = each.key  // each module
   lclist     = var.client-2-dscg[each.key] // for each LC 
   trafficmode = var.trafficmode
   lineptpid = var.module_carriers[each.key].lineptpid
   carrierid = var.module_carriers[each.key].carrierid

}

// leaf
module "lc-leaf" {
  source = "./lc"
 
  for_each   = toset(var.leaf_names)
   n          = each.key // each module
   lclist     = var.client-2-dscg[each.key] // for each LC 
   trafficmode = var.trafficmode
   lineptpid = var.module_carriers[each.key].lineptpid
   carrierid = var.module_carriers[each.key].carrierid

}