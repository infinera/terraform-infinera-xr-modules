output "hub_dscs" {
  #value = { for dscid, dsc in xrcm_dsc.dsc : dscid => dsc }
  value = xrcm_dsc.dsc
}