/*
for each hub, just one hub supported
  for each hub dsc
    enable txenabled if hub as a BW entry for this DSC
    enable rxenabled if leaf has a BW entry for this DSC
*/

module "hub-dsc" {
  source = "./hub-dsc"

  for_each        = toset(var.hub_names)
  dscidlist       = var.hubdscids
  tx_bandwithlist = flatten([for k in var.hub_bandwidth[each.key] : k["hubdscidlist"]])
  rx_bandwithlist = flatten([for k in values(var.leaf_bandwidth) : [for ki in k : ki["hubdscidlist"]]])
  n               = each.value
  lineptpid       = 1
  carrierid       = 1
}
/*
for each leaf 
  for each leaf dsc
    enable dsc.txenabled - if leaf has leaf BW else false
    enable dsc.rxenabled- if hub has matching hub BW for this leaf BW else false
    set dsc.constellationid to matching hub DSC ids 
    
*/

module "leaf-dsc" {
  source = "./leaf-dsc"


  for_each               = toset(var.leaf_names)
  dscidlist              = var.leafdscids
  rx_bandwithlist        = flatten([for k, v in var.leaf_bandwidth[each.key] : { for ki, vi in var.hub_bandwidth[var.hub_names[0]][k] : ki => vi if ki == "hubdscidlist" }][*].hubdscidlist)
  tx_bandwithlist        = flatten([for k in var.leaf_bandwidth[each.key] : k["hubdscidlist"]])
  leafdscidlist          = flatten([for k in var.leaf_bandwidth[each.key] : k["leafdscidlist"]])
  constellationdscidlist = flatten([for k, v in var.leaf_bandwidth[each.key] : { for ki, vi in var.hub_bandwidth[var.hub_names[0]][k] : ki => vi if ki == "hubdscidlist" }][*].hubdscidlist)
  n                      = each.value
  lineptpid              = 1
  carrierid              = 1
}


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
