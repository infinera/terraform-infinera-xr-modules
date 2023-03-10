# Get Checked Resources

## Description

Get and check the devices' resources for the specified resource type. The checked resources have the attributes which has been compared with the intent and Host control.  
I.E. For the Check Condition is NonHostAttribute; the device attribute will meet this condition if it is not owned (controlled) by the Host.

## Inputs

1. Resource Type

```
// resource type
variable resource_type {
  type = string
  default = "Carrier"
  // Device, DeviceConfig, Ethernet, Carrier, DSC, DSCG
}
```

1. Devices'Resources: List of devices' checked resources. **Only need to specify _Devices'Resources_ if the _Network_ is not specified**.

```
variable devices_resources {
  type =  list(object({ n= string, resourcetype = string, deviceid = optional(string)
                        resources = list(object({resourceid = string, attributevalues = string, controlattribute = optional(string), parentid= optional(string), grandparentid = optional(string), attributevalues = optional(list(object({attribute=string, intentvalue= string, devicevalue=optional(string), controlattribute= optional(string),isvaluematch=optional(bool), attributecontrolbyhost = optional(bool)})))})) }))
  default = []
}
```

1. Network: For each device, specify its Device, Device config, its Client Ports and Line Carriers. **Only need to specify _Network_ if the _Devices'Resources_ is not specified**.

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

1. Checked Devices Resources: _checked_resources_: The checked devices'resources for the specified resource type.

```
   checked_resources = list(object({ n= string, resourcetype = string,
                                     resources = list(object({resourceid = string, attributevalues = string, controlattribute = string,
                                                              parentid= optional(string), parentid= optional(string), grandparentid = optional(string)})) }))
}
```

## Usage:

```
module  "get_checked_resources"{
  source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//utils/get_checked_resources"

  network = var.network
  resource_type = "Device"
}

output "checked_resources" {
  value = module.get_checked_resources.checked_resources
}
```

## Usage References:
