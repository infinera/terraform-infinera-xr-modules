# Util: Filter Checked Resources
This utils module filter out the checked resources
## How to Run 
  1. Go to the **filter_checked_resources** directory or its clone directory
     1. Assumption: *terraform init* was executed before (only one time) to initialize the terraform setup.
  2. Specify the input variables by updating the *AAA.auto.tfvars* input file. 
     1. The network intent
  3. Execute *terraform apply* to run using the input from *AAA.auto.tfvars* or *terraform -apply -var-file="AAA.tfvars"*. 

*main.tf* in **filter_checked_resources** directory
```
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
```
## Usage: Utils [get_and_filter_checked_resources](https://github.com/infinera/terraform-infinera-xr-modules/tree/main/utils/get_and_filter_checked_resources)
## Description
Below is the run sequence
### check the intent device resources' attribute against the network device attributes

## Inputs
### filter : 
```
variable filter {
  type = string
  default = "Mismatched"
  #  Support Values = HostAttribute, HostAttributeNMismatched, HostAttributeNMatched, NonHostAttribute, NonHostAttributeNMismatched, NonHostAttributeNMatched,  Matched, Mismatched
}
```
### Devices'Resources: 
```
variable devices_resources {
  type =  list(object({ n= string, resourcetype = string, deviceid = optional(string)
                        resources = list(object({resourceid = string, attributevalues = string, controlattribute = optional(string), parentid= optional(string), grandparentid = optional(string), attributevalues = optional(list(object({attribute=string, intentvalue= string, devicevalue=optional(string), controlattribute= optional(string),isvaluematch=optional(bool), attributecontrolbyhost = optional(bool)})))})) }))
  default = []
}
```