output "leaf_dscgs" {
  #value = { for dscid, dsc in xrcm_dsc.dsc : dscid => dsc }
  value = xrcm_dscg.dscg
}