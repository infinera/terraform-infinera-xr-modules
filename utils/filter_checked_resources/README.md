# Filter Checked Resources

## Description
Find the devices' checked resources that meet the condition. The checked resources have the attributes which has been compared with the intent and Host control. I.E. If the Check Condition is NonHostAttribute; the device attribute will meet this condition if it is not owned (controlled) by the Host.

## Inputs
1. Filter: The filter (condition) to apply to the specified List of devices' checked resources. 
```
variable filter {
  type = string
  default = "Mismatched"
  #  Support Values = HostAttribute, HostAttributeNMismatched, HostAttributeNMatched, NonHostAttribute, NonHostAttributeNMismatched, NonHostAttributeNMatched,  Matched, Mismatched
}
```
2. Devices'Resources: List of devices' checked resources.
```
variable devices_resources {
  type =  list(object({ n= string, resourcetype = string, deviceid = optional(string)
                        resources = list(object({resourceid = string, attributevalues = string, controlattribute = optional(string), parentid= optional(string), grandparentid = optional(string), attributevalues = optional(list(object({attribute=string, intentvalue= string, devicevalue=optional(string), controlattribute= optional(string),isvaluematch=optional(bool), attributecontrolbyhost = optional(bool)})))})) }))
  default = []
}
```
## Outputs
1. Devices Resources: *resources*: The devices'resources which meet the condition. It is a map of device name to the array of its matched resources.
```
   resources = object ({  n= string, resourcetype = string, deviceid = optional(string)
              resources = list(object({resourceid = string, attributevalues = string, controlattribute = optional(string), parentid= optional(string), 
              grandparentid = optional(string), attributevalues = optional(list(object({attribute=string, intentvalue= string, devicevalue=optional(string),
              controlattribute= optional(string),isvaluematch=optional(bool), attributecontrolbyhost = optional(bool)}
```
2. Device_Names *device_names*: The list of device names which has attributes met the condition 
```
  device_names = list(string)
```
## Usage:
```
module "filter_checked_resources" {
  source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//utils/filter_checked_resources"

  filter = var.filter
  devices_resources = data.xrcm_check_resources.resources.queries
}

output "filter_checked_resources" {
  value = module.filter_checked_resources.resources
}
output "filter_checked_resources_device_names" {
  value = module.filter_checked_resources.device_names
}
```
## Usage References: 
* [get_and_filter_checked_resources](https://github.com/infinera/terraform-infinera-xr-modules/tree/main/utils/get_and_filter_checked_resources)