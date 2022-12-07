# Network Attrbute Check Module
This module will check the intent device resources' attribute against the network device attributes
## How to Run 
  1. Go to the **network_attrbute_check** directory or its clone directory
     1. Assumption: *terraform init* was executed before (only one time) to initialize the terraform setup.
  2. Specify the input variables by updating the *AAA.auto.tfvars* input file. 
     1. The network intent
  3. Execute *terraform apply* to run using the input from *AAA.auto.tfvars* or *terraform -apply -var-file="AAA.tfvars"*. This will configure the constellation network with the specified asserted conditions

*main.tf* in **network_attrbute_check** directory
```
module  "get_and_filter_checked_resources"{
  source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//utils/get_and_filter_checked_resources"
  //source = "../../utils/get_and_filter_checked_resources"

  network = var.network
  resource_type = var.resource_type
  filter = var.condition
}

locals {
  resources = module.get_and_filter_checked_resources.resources
  device_names = module.get_and_filter_checked_resources.device_names
  found = length(local.device_names) > 0
  checks_outputs = local.found ? [for k,v in local.resources : "Module:${upper(k)}, resources: ${jsonencode(v)}"] : []
  upper_device_names = [for k in local.device_names : "${upper(k)}"]
}

output "message" {
  value = local.found && !var.assert ? "Not Assert. Devices with <<${var.condition}>> attributes:\n${join("\n", local.checks_outputs)}\n\nAction: Continue to run" : ""
}

// check module with mismatched version
data "xrcm_check" "checks" {
  depends_on = [module.get_and_filter_checked_resources] 

  count = var.assert ? 1 : 0
  condition = local.found
  description = "Devices with <<${var.condition}>> attributes: ${join(":::", local.upper_device_names)}"
  throw = "Devices with <<${var.condition}>> attributes:\n${join("\n", local.checks_outputs)}\n\nHost attributes can not be updated by IPM.\nTo continue the run for other devices which has no configuration on Host attributes; please set 'assert' to false"
}

output "resources" {
  value = local.resources
}

output "device_names" {
  value = local.device_names
}

```
## Description
Below is the run sequence
### check the intent device resources' attribute against the network device attributes

## Inputs
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





