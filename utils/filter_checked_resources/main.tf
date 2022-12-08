terraform {
  required_providers {
    xrcm = {
      source = "infinera.com/poc/xrcm"
    }
  }
}
// Find the resources that meet the checked condition. I.E. If the Check Condition is NonHostAttribute; the device attribute will meet this condition if it is not owned (controlled) by the Host.
locals {
  raw_resources_attributes = var.filter == "HostAttributeNMismatched" ? {for device in var.devices_resources: device.n => flatten([ for res in device.resources : [for attributevalue in res.attributevalues : merge({ resourceid =  res.resourceid, parentid = res.parentid != null ? res.parentid : "", grandparentid = res.grandparentid != null ? res.parentid : "", resourcetype = device.resourcetype}, attributevalue) if ( attributevalue.isvaluematch == false && attributevalue.attributecontrolbyhost == true ) ] ]) }  : var.filter == "HostAttribute" ? {for device in var.devices_resources: device.n => flatten([ for res in device.resources : [for attributevalue in res.attributevalues : merge({ resourceid =  res.resourceid, parentid = res.parentid != null ? res.parentid : "", grandparentid = res.grandparentid != null ? res.parentid : "", resourcetype = device.resourcetype}, attributevalue) if ( attributevalue.attributecontrolbyhost == true ) ] ]) } : var.filter == "Mismatched" ?  {for device in var.devices_resources: device.n => flatten([ for res in device.resources : [for attributevalue in res.attributevalues : merge({ resourceid =  res.resourceid, parentid = res.parentid != null ? res.parentid : "", grandparentid = res.grandparentid != null ? res.parentid : "", resourcetype = device.resourcetype}, attributevalue) if ( attributevalue.isvaluematch == false ) ] ]) } : var.filter == "HostAttributeNMatched" ?  {for device in var.devices_resources: device.n => flatten([ for res in device.resources : [for attributevalue in res.attributevalues : merge({ resourceid =  res.resourceid, parentid = res.parentid != null ? res.parentid : "", grandparentid = res.grandparentid != null ? res.parentid : "", resourcetype = device.resourcetype}, attributevalue) if ( attributevalue.isvaluematch == true && attributevalue.attributecontrolbyhost == true ) ] ]) } : var.filter == "NonHostAttributeNMismatched" ?  {for device in var.devices_resources: device.n => flatten([ for res in device.resources : [for attributevalue in res.attributevalues : merge({ resourceid =  res.resourceid, parentid = res.parentid != null ? res.parentid : "", grandparentid = res.grandparentid != null ? res.parentid : "", resourcetype = device.resourcetype}, attributevalue) if ( attributevalue.isvaluematch == false && attributevalue.attributecontrolbyhost == false ) ] ]) } : var.filter == "NonHostAttributeNMatched" ?  {for device in var.devices_resources: device.n => flatten([ for res in device.resources : [for attributevalue in res.attributevalues : merge({ resourceid =  res.resourceid, parentid = res.parentid != null ? res.parentid : "", grandparentid = res.grandparentid != null ? res.parentid : "", resourcetype = device.resourcetype}, attributevalue) if ( attributevalue.isvaluematch == true && attributevalue.attributecontrolbyhost == false ) ] ]) } : var.filter == "Matched" ?  {for device in var.devices_resources: device.n => flatten([ for res in device.resources : [for attributevalue in res.attributevalues : merge({ resourceid =  res.resourceid, parentid = res.parentid != null ? res.parentid : "", grandparentid = res.grandparentid != null ? res.parentid : "", resourcetype = device.resourcetype}, attributevalue) if ( attributevalue.isvaluematch == true ) ] ]) } : var.filter == "NonHostAttribute" ?  {for device in var.devices_resources: device.n => flatten([ for res in device.resources : [for attributevalue in res.attributevalues : merge({ resourceid =  res.resourceid, parentid = res.parentid != null ? res.parentid : "", grandparentid = res.grandparentid != null ? res.parentid : "", resourcetype = device.resourcetype}, attributevalue) if (  attributevalue.attributecontrolbyhost == false ) ] ]) }: {}
  
  resources_attributes = { for k, v in local.raw_resources_attributes: k => v if length(v) > 0 }
  
  device_names = [for k,v  in local.resources_attributes : upper("${k}") if length(v) > 0]
}

// The devices'resources which meet the condition. It is a map of device name to the array of its matched resources.
// The resource is a object as shown below
// object ({ n= string, resourcetype = string, deviceid = optional(string)
//   resources = list(object({resourceid = string, attributevalues = string, controlattribute = optional(string), parentid= optional(string), 
//   grandparentid = optional(string), attributevalues = optional(list(object({attribute=string, intentvalue= string, devicevalue=optional(string),
//   controlattribute= optional(string),isvaluematch=optional(bool), attributecontrolbyhost = optional(bool)}

output "resources" {
  value = local.resources_attributes
}

// The list of device names which has attributes met the condition
output device_names {
  value = local.device_names
}