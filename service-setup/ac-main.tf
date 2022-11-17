// Configuring Hub and Leaf modules

module "ac" {
  source = "./ac"
  
  for_each   = var.trafficmode == "L2Mode" ? var.client-2-dscg : {}
    n          = each.key // each module
    aclist     = each.value // for each AC 
    trafficmode = var.trafficmode
    online = contains(var.hub_names, each.key) || contains(var.leaf_names, each.key)
    module_clients = var.module_clients
}

