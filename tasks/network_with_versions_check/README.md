# Network With Versions Check

## Description

This task will check the devices' versions against the devices's intent versions.

## Inputs

1. Asserts : If assert is true, the run will stop when there is a mismatched device version

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

1. Devices Resources: _resources_: The devices'resources which have different version. It is a map of device name to the array of its matched resources.

```
   resources = object ({  n= string, resourcetype = string, deviceid = optional(string)
              resources = list(object({resourceid = string, attributevalues = string, controlattribute = optional(string), parentid= optional(string),
              grandparentid = optional(string), attributevalues = optional(list(object({attribute=string, intentvalue= string, devicevalue=optional(string),
              controlattribute= optional(string),isvaluematch=optional(bool), attributecontrolbyhost = optional(bool)}
```

2. Device_Names _device_names_: The list of device names which has attributes met the condition

```
  device_names = list(string)
```

3. Deviceid Checks Outputs: A list of formatted display strings for the devices and their Mismatched IDs

```
device_version_checks_outputs = list(string) // ["Device:device_name Device_Version: device_version, Intent_Version: intent_version]
```

## Usage:

```
module  "network_with_versions_check" {
  source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//tasks/network_with_versions_check"

  network = var.network
  assert = var.assert
}

output "device_names" {
  value = module.network_with_IDs_check.device_names
}

output "resources" {
  value = module.network_with_versions_check.resources
}

output "device_version_checks_outputs" {
  value = module.network_with_versions_check.device_version_checks_outputs
}
```

## Usage Refereences

- [Network Setup With Version Check Workflow](https://github.com/infinera/terraform-infinera-xr-modules/tree/main/workflows/setup_network_with_checks)
