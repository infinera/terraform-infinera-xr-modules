# Network With IDs Check

## Description

This task will check the TF State device IDs against the network device IDs. The TF State stores the current constellation coniguration which includes its devices and their properties such as device ID.

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
    deviceclients = optional(list(object({clientaid = string, portspeed = optional(string)}))),
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
      deviceclients = [{ clientaid = "1", portspeed="200"}, { clientaid = "2",portspeed="200"}]
      devicecarriers = [{ lineptpid = "1", carrierid = "1", modulation ="16QAM"}]
    }
  }
```

## Outputs

1. Devices: Map of the device name and device ID comparison result

```
devices = map(object({tfstate_deviceid = string, network_deviceid = string}))
```

2. Device Names: The list of device names which have mismatched IDs

```
device_names = list(string)
```

3. Deviceid Checks Outputs: A list of formatted display strings for the devices and their mismatched versions

```
deviceid_checks_outputs = list(string) // [{Module:module_name, DeviceID: deviceid, tfstateDeviceID: tfstate_deviceid"}]
```

## Usage:

```
module  "network_with_IDs_check" {
  source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//tasks/network_with_IDs_check"

  network = var.network
  assert = var.assert
}

output "device_names" {
  value = module.network_with_IDs_check.device_names
}

output "devices" {
  value = module.network_with_IDs_check.devices
}

output "Deviceid Checks Outputs" {
  value = module.network_with_IDs_check.Deviceid Checks Outputs
}
```

## Usage Refereences

- [Network Device Replacement Workflow](https://github.com/infinera/terraform-infinera-xr-modules/tree/main/workflows/network_device_replacement)
