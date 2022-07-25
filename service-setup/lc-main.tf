/* Configuring Hub and Leaf modules
*/

module "lc" {
  source = "./lc"

  

 
  for_each   = var.client-2-dscg
   n          = each.key // each module
   lclist     = each.value // for each LC 
 

}

