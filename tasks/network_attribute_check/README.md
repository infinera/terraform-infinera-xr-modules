# Network Attributes Check

## Description

This task will check the intent device resources' attribute against the network device attributes

## Inputs

1. Assert: If assert is true, the run will stop when the specified condition is met.

```
variable assert {
  type = bool
  default = true
}
```

2. Resource Type: The resource typw to be checked.

```
variable resource_type {
  type = string
  default = "Ethernet"
}
```

3. Condition: The condition that will trigger the assertion

```
variable condition {
  type = string
  default = "Mismatched"
}
```

4. Network: For each device, specify its Device, Device config, its Client Ports and Line Carriers.

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
      device = { sv = "1.00"}
      deviceconfig = { configuredrole = "hub", trafficmode ="L1Mode"}
      deviceclients = [{ clientaid = "1", portspeed="200"}, { clientaid = "2",portspeed="200"}]
      devicecarriers = [{ lineptpid = "1", carrierid = "1", modulation ="16QAM"}]
    }
  }
```

## Outputs :

1. Devices Resources: _resources_: The devices'resources which meet the condition. It is a map of device name to the array of its matched resources.

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

## Usage

```
// Set up the Constellation Network
module "network_attribute_check" {

  source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//tasks/network_attribute_check"

  network = var.network
  resource_type = "Ethernet"
  condition = "Mismatched"
  assert = true
}

output "resources" {
  value = module.network_attribute_check.resources
}

output "device_names" {
  value = module.network_attribute_check.device_names
}
```

## Usage Reference:
