/* xr.carrier */

module "hub-carrier" {
  source     = "./hub-carrier"
  depends_on = [module.hub-cfg]
  for_each   = toset(var.hub_names)
  hub_n      = each.value

}

module "leaf-carrier" {
  depends_on = [module.hub-carrier]
  source     = "./leaf-carrier"
  for_each   = toset(var.leaf_names)
  leafname   = each.value
  //  aid = var.leaf_names[count.index]

}
