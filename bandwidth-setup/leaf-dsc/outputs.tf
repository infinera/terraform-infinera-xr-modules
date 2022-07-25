output "leaf_dscs" {
  #value = { for dscid, dsc in xrcm_dsc.dsc : dscid => dsc }
  value = module.leaf-dsc
}