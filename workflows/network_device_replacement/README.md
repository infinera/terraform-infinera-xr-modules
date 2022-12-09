# Workflow: Network Device Replacement

## Description
This workflow shall provision a constellation network as shown below
  1. Find the devices with the same name but different network ID and TF state ID
     1. Get the devices and their IDs in the current TF state. The TF state can be local or remote (Remote TF state shall be supported in later release)
     2. Get the Devices' propery from the network. The device property has the network device ID
     3. Compare the devices and their IDs in [1] and [2] to derive the different IDs device list
  2. Provision the network with the filtered devices. The filtered devices are the devices with the same name but different network ID and TF state ID found in step 1. During the *terraform apply*,
     1. The filtered devices shall be removed from the intent; Hence their resources are deleted during the run. In addition, all other related resources shall be updated as needed.
     2. The constellation is created or updated for all the specified devices not in the filtered device list.
   
> *** Notes *** However to complete the Device Replacement with all populated resources, this workflow must be run twice. 
     1. First *terraform apply* to clean up the resources for the filtered devices (with the same name but different network ID and TF state ID)
     2. Second *terraform apply* to create all resources for the filtered devices in step 1 but they do not have diffent IDs after the first *terraform apply* (Device's network ID and TF state ID are the same)
## inputs
1. Asserts : If assert is true, the run will stop when there is a device which the same name but different IDs. This is the cases of device replacement or swapping in a constellation network.
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
3. Bandwidth: Specify both Hub and Leaf Bandwidths
  - Hub Bandwidth: Defines the bandwidth to provisioned between Hub and each leaf. For each leaf, define the Hub DSC ids to be assigned to the BW, and the Hub DSCG id and Leaf DSCG id to be used to create the DSCG. Creates Hub DSCGs.
    ```
    variable "hub_bandwidth" {
      type = map(map(object({ hubdscgid = optional(string), leafdscgid = optional(string), hubdscidlist = optional(list(string)), leafdscidlist = optional(list(string)), direction = optional(string) })))

    Example:
    hub_bandwidth = {
      xr-regA_H1-Hub = { // For each DSCG create a entry, ds = hubdscidlist, us = leafdscidlist. 
      // for each dsc specified in hubdscidlist THD tx, rx enabled
      xr-regA_H1-Hub-BW5173ds = { hubdscgid = "1", leafdscgid = "1", hubdscidlist = ["5", "1", "7", "3"], leafdscidlist = ["1", "2", "3", "4"], direction = "ds" }
      xr-regA_H1-Hub-BW2468ds = { hubdscgid = "2", leafdscgid = "1", hubdscidlist = ["2", "4", "6", "8"], leafdscidlist = ["1", "2", "3", "4"], direction = "ds" },
      },
    }
    ```
  - Leaf bandwidth: Defines the bandwidth to provisioned between Hub and each leaf. For each leaf, define the Hub DSC ids to be assigned to the BW, and the Hub DSCG id and Leaf DSCG id to be used to create the DSCG. Creates Leaf DSCGs.
    ```
    variable "leaf_bandwidth" {
      type = map(map(object({ hubdscgid = string, leafdscgid = string, hubdscidlist = list(string), leafdscidlist = list(string), direction = string
      // direction possible values: bidi, us, ds
      })))
    }

    Example
    leaf_bandwidth = {
      xr-regA_H1-L1 = {       
        xr-regA_H1-Hub-BW5173ds = { hubdscgid = "3", leafdscgid = "2", hubdscidlist = ["5"], leafdscidlist = ["1"], direction = "us" }
      }
    }
    ```
4. Services: Defines the local connections for each node in the network. Each conection includes the Cliend id and DSCG id
```
variable "client-2-dscg" {
  type = map(map(object({ clientindex = optional(number) // index to module_clients list
                          dscgid   = optional(string)
                          lctype = optional(string)
                          capacity = optional(number)
                          imc = optional(string)
                          imc_outer_vid = optional(string)
                          emc = optional(string)
                          emc_outer_vid = optional(string) 
                        })))
}

Example:
client-2-dscg = {
  xr-regA_H1-Hub = { // hub tx -> leaf 1/2/3/4 - 100G Shared downstream
    lc-XR-SFO_12-1234-1-ds = { 
    clientindex = 0
    dscgid   = "1"
    lctype = "uniDirDs"
    capacity = 4
    imc = "MatchAll"
    imc_outer_vid = ""
    emc = "None"
     emc_outer_vid = ""
  }, 
  lc-xr-regA_H1-L1-1-us = { // hub rcv <- leaf 1, 25G US
    clientindex = 0
    dscgid   = "3" // US DSCG ID 
    lctype = "uniDirUs"
    capacity = 1
    imc = "None" 
    imc_outer_vid = ""
    emc = "MatchOuterVID"
    emc_outer_vid = "100"       
  }
}
```
### Outputs: Network is cleanup after first run and create after second run
1. Message: display the different IDs devices
```
 message = string
```
## Usage
```
module "network_device_replacement" {
  source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//workflows/network_device_replacement"
  
  assert = var.assert
  network = var.network
  leaf_bandwidth = var.leaf_bandwidth
  hub_bandwidth = var.hub_bandwidth
  client-2-dscg     = var.client-2-dscg
}

output "message" {
  value = module.network_device_replacement.message
}
```
## Usage Reference
* [Network Replacement Use Case](https://github.com/infinera/terraform-xr-network/tree/main/use_cases/network_replacement)
