locals {
    leaf-names = [ for k1,v1 in var.leaf-2-hub-dscids : k1]
    leaf-dscids =  { for k1,v1 in var.leaf-2-hub-dscids : k1 => flatten([ for k2, v2 in v1 : v2["leafdscidlist"]])}
    hub-dscids =  { for k1,v1 in var.leaf-2-hub-dscids : k1 => flatten([ for k2, v2 in v1 : v2["leafdscidlist"]])}
    diag-tests = { for k1,v1 in var.hub-leaf-dscs-diag : k1 => values(v1)[0]}
  }

module "hub-dscs-diag" {
  source = "./hub-dscs-diag"

  for_each = toset(local.leaf-names)
    dscids    = local.hub-dscids[each.value]
    n         = var.hub_names[0]
    portid    = 1
    carrierid = 1
    facprbsgenenabled = local.diag-tests[each.value]["hubfacprbsgen"] == "enabled" ? true : false 
    facprbsmonenabled = local.diag-tests[each.value]["hubfacprbsmon"] == "enabled" ? true : false
}

module "leaf-dscs-diag" {
  source = "./leaf-dscs-diag"

  for_each = toset(local.leaf-names)
    dscids    = local.leaf-dscids[each.value]
    n         = each.value
    portid    = 1
    carrierid = 1
    facprbsgenenabled = local.diag-tests[each.value]["hubfacprbsmon"] == "enabled" ? true : false 
    facprbsmonenabled = local.diag-tests[each.value]["hubfacprbsgen"] == "enabled" ? true : false
}
