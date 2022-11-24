
module "hub-cfg" {
  source = "./hub-cfg"
  for_each = toset( var.hub_names)
    hub_n  = each.value
}

// Example of depends on 
module "leafs-cfg" {
  source = "./leaf-cfg"

  depends_on = [module.hub-cfg]
  for_each = toset( var.leaf_names)
    n     = each.value
 
}
