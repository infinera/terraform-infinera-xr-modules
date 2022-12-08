# Get Devices With Same Name But Different IDs

## Description
Get devices with same name but different IDs. The Devices' IDs are retrieved from the current TF state in the previous *terraform apply* and from the network (Get from Plgd server)

## Inputs
1. Device Names: the list of device names which will be used to compare the IDs
```
variable "device_names" {
  type    = list
  default = ["xr-regA_H1-L1", "xr-regA_H1-Hub"]
}
```
2. State: Only the devices in the device name list which states match the specified state are used.
```
variable "state" {
  type    = string
  default = "ONLINE"
}
```
## Outputs
1. Devices: *devices*: Map of the device name and device ID comparison result
```
   devices = map(object({tfstate_deviceid = string, network_deviceid = string}))
```
## Usage:
```
module  "get_devices_with_different_ids"{
  source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//utils/get_devices_with_different_ids"

  device_names = ["xr-regA_H1-L1", "xr-regA_H1-Hub"]
  state = "ONLINE"
}

output "device_with_different_ids" {
  value = module.get_devices_with_different_ids.devices
}
```
## Usage References: 
* [Network With ID Checks](https://github.com/infinera/terraform-infinera-xr-modules/tree/main/tasks/network_with_IDs_check)

