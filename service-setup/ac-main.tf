/* Configuring Hub and Leaf modules

*/

// Hub
module "ac" {
  source = "./ac"
  
  for_each   = var.trafficmode == "L2Mode" ? var.client-2-dscg : {}
    n          = each.key // each module
    aclist     = each.value // for each AC 
    trafficmode = var.trafficmode
}

