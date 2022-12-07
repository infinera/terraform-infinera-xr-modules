terraform {
  required_providers {
    xrcm = {
      source = "infinera.com/poc/xrcm"
    }
  }
}

locals {
  raw_resources_attributes = var.filter == "HostAttributeNMismatched" ? {for device in var.devices_resources: device.n => flatten([ for res in device.resources : [for attributevalue in res.attributevalues : merge({ resourceid =  res.resourceid, parentid = res.parentid != null ? res.parentid : "", grandparentid = res.grandparentid != null ? res.parentid : "", resourcetype = device.resourcetype}, attributevalue) if ( attributevalue.isvaluematch == false && attributevalue.attributecontrolbyhost == true ) ] ]) }  : var.filter == "HostAttribute" ? {for device in var.devices_resources: device.n => flatten([ for res in device.resources : [for attributevalue in res.attributevalues : merge({ resourceid =  res.resourceid, parentid = res.parentid != null ? res.parentid : "", grandparentid = res.grandparentid != null ? res.parentid : "", resourcetype = device.resourcetype}, attributevalue) if ( attributevalue.attributecontrolbyhost == true ) ] ]) } : var.filter == "Mismatched" ?  {for device in var.devices_resources: device.n => flatten([ for res in device.resources : [for attributevalue in res.attributevalues : merge({ resourceid =  res.resourceid, parentid = res.parentid != null ? res.parentid : "", grandparentid = res.grandparentid != null ? res.parentid : "", resourcetype = device.resourcetype}, attributevalue) if ( attributevalue.isvaluematch == false ) ] ]) } : var.filter == "HostAttributeNMatched" ?  {for device in var.devices_resources: device.n => flatten([ for res in device.resources : [for attributevalue in res.attributevalues : merge({ resourceid =  res.resourceid, parentid = res.parentid != null ? res.parentid : "", grandparentid = res.grandparentid != null ? res.parentid : "", resourcetype = device.resourcetype}, attributevalue) if ( attributevalue.isvaluematch == true && attributevalue.attributecontrolbyhost == true ) ] ]) } : var.filter == "NonHostAttributeNMismatched" ?  {for device in var.devices_resources: device.n => flatten([ for res in device.resources : [for attributevalue in res.attributevalues : merge({ resourceid =  res.resourceid, parentid = res.parentid != null ? res.parentid : "", grandparentid = res.grandparentid != null ? res.parentid : "", resourcetype = device.resourcetype}, attributevalue) if ( attributevalue.isvaluematch == false && attributevalue.attributecontrolbyhost == false ) ] ]) } : var.filter == "NonHostAttributeNMatched" ?  {for device in var.devices_resources: device.n => flatten([ for res in device.resources : [for attributevalue in res.attributevalues : merge({ resourceid =  res.resourceid, parentid = res.parentid != null ? res.parentid : "", grandparentid = res.grandparentid != null ? res.parentid : "", resourcetype = device.resourcetype}, attributevalue) if ( attributevalue.isvaluematch == true && attributevalue.attributecontrolbyhost == false ) ] ]) } : var.filter == "Matched" ?  {for device in var.devices_resources: device.n => flatten([ for res in device.resources : [for attributevalue in res.attributevalues : merge({ resourceid =  res.resourceid, parentid = res.parentid != null ? res.parentid : "", grandparentid = res.grandparentid != null ? res.parentid : "", resourcetype = device.resourcetype}, attributevalue) if ( attributevalue.isvaluematch == true ) ] ]) } : var.filter == "NonHostAttribute" ?  {for device in var.devices_resources: device.n => flatten([ for res in device.resources : [for attributevalue in res.attributevalues : merge({ resourceid =  res.resourceid, parentid = res.parentid != null ? res.parentid : "", grandparentid = res.grandparentid != null ? res.parentid : "", resourcetype = device.resourcetype}, attributevalue) if (  attributevalue.attributecontrolbyhost == false ) ] ]) }: {}
  
  resources_attributes = { for k, v in local.raw_resources_attributes: k => v if length(v) > 0 }
  
  device_names = [for k,v  in local.resources_attributes : upper("${k}") if length(v) > 0]
}

output "resources" {
  value = local.resources_attributes
}

output device_names {
  value = local.device_names
}
 

