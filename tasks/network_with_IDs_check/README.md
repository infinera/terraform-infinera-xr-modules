# Task: Network Attrbute Check
This task will check the TF State device IDs against the network device IDs. The TF State stores the current constellation coniguration which includes its devices and their properties such as device ID.
  1. Go to the **network_with_IDs_check** directory or its clone directory
     1. Assumption: *terraform init* was executed before (only one time) to initialize the terraform setup.
  2. Specify the input variables by updating the *AAA.auto.tfvars* input file. 
     1. The network intent
  3. Execute *terraform apply* to run using the input from *AAA.auto.tfvars* or *terraform -apply -var-file="AAA.tfvars"*. 

*main.tf* in **network_with_IDs_check** directory
```
module  "get_devices_with_different_ids"{
  source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//utils/get_devices_with_different_ids"
  //source = "../../utils/get_devices_with_different_ids"

  device_names = [for k,v in var.network.setup: k]
  state = "ONLINE"
}

locals {
  devices = module.get_devices_with_different_ids.devices
  ids_mismatched = local.devices != null ? length(local.devices) > 0 : false
  deviceid_checks_outputs = local.ids_mismatched ? [for k,v in local.devices : "Module:${upper(k)}, DeviceID: ${v.network_deviceid}, tfstateDeviceID: ${v.tfstate_deviceid}"] : []
  device_names = local.ids_mismatched ? [for k,v in local.devices : k ] : []
  upper_device_names = [for k in local.device_names : upper("${k}")]
}

output "message" {
  value = local.ids_mismatched && !var.assert ? "Not Assert. ID(s) Mismatched:\n${join("\n", local.deviceid_checks_outputs)}\n\nAction: Continue to run with filtering the mismatched devices listed above" : ""
}

// check module with same name but ID is diff
data "xrcm_check" "check_deviceid_mismatched" {
  depends_on = [module.get_devices_with_different_ids] 

  count = var.assert ? 1 : 0
  condition = local.ids_mismatched
  description = "Devices ids are mismatched: ${join(", ", local.upper_device_names)}"
  throw = "ID(s) Mismatched:\n${join("\n", local.deviceid_checks_outputs)}"
}

output "devices" {
   value = local.devices
}

output "deviceid_checks_outputs" {
   value = local.ids_mismatched ? local.deviceid_checks_outputs : []
}

output "device_names" {
  value = local.device_names
}

```
## Description
Below is the run sequence
### check the intent device resources' attribute against the network device attributes

## Inputs
### Asserts : If assert is true, the run will stop when there is a mismatched host attribute
```
variable assert { 
  type = bool
  default = true 
}
```
### Network: For each device, specify its Device, Device config, its Client Ports and Line Carriers.
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




