# Network Mismatched Host Attributes Check
## Description
This task will check for any mismatched host attribute and stop the run if teh *assert* is true
## Inputs
1. Asserts : If assert is true, the run will stop when there is a mismatched host attribute
```
variable assert { 
  type = bool
  default = true 
}
```
2. Network: For each device, specify its Device, Device config, its Client Ports and Line Carriers.
```
variable network {
  type = object({
    configs = object({ portspeed = optional(string), trafficmode = optional(string), modulation = optional(string) })
    setup = map(object({ device  = optional(object( {di = optional(string), sv = optional(string)})),
    deviceconfig  = optional(object( {fiberconnectionmode = optional(string), tcmode = optional(bool), configuredrole = optional(string), trafficmode = optional(string)})),
    deviceclients = optional(list(object({clientid = string, portspeed = optional(string)}))),
    devicecarriers= optional(list(object({lineptpid = string, carrierid = string, modulation = optional(string), clientportmode = optional(string),constellationfrequency = optional(number)})))
    }))
  })
}

Example:
network = {
  configs = { portspeed = "", trafficmode = "L1Mode", modulation = "" }
  setup = {
    xr-regA_H1-Hub = {
      device = { di = "76e073d6-4570-4111-4853-3bd52878dfa2", sv = "1.00"}
      deviceconfig = { configuredrole = "hub", trafficmode ="L1Mode"}
      deviceclients = [{ clientid = "1", portspeed="200"}, { clientid = "2",portspeed="200"}]
      devicecarriers = [{ lineptpid = "1", carrierid = "1", modulation ="16QAM"}] 
    }
  }
```
## Outputs
1. Device Names: List of the device names which has mismatched host attributes
```
   device_names = list(string)
```
2. Devices Resources: *resources*: The devices'resources which meet the Mismatched Host Attribute condition. It is a map of device name to the array of its matched resources.
```
   resources = map(object ({  n= string, resourcetype = string, deviceid = optional(string)
              resources = list(object({resourceid = string, attributevalues = string, controlattribute = optional(string), parentid= optional(string), 
              grandparentid = optional(string), attributevalues = optional(list(object({attribute=string, intentvalue= string, devicevalue=optional(string),
              controlattribute= optional(string),isvaluematch=optional(bool), attributecontrolbyhost = optional(bool)}))
```
3. Mismatched Host Attribute Check Outputs: A list of formatted display strings for the devices and their Mismatched Host Attributes
```
   mismatched_host_attribute_check_outputs = list[string] /[{Module: module_name, resources: [resource]}"]
```
## Usage: 
```
module "network_host_mismatch_attribute_check" {
  source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//tasks/network_host_mismatch_attribute_check"
  
  network = var.network
  assert = "HostAttributeNMismatched"
}

output "resources" {
   value = module.network_host_mismatch_attribute_check.resources
}

output "mismatched_host_attribute_check_outputs" {
   value = module.network_host_mismatch_attribute_check.mismatched_host_attribute_check_outputs
}

output "device_names" {
  value = module.network_host_mismatch_attribute_check.device_names
}
```
## Usage Reference
* [Network Setup With Checks Workflow](https://github.com/infinera/terraform-infinera-xr-modules/tree/main/workflows/setup_network_with_checks)

