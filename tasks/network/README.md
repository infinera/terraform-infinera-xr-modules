# Setup Network

## Description

This module will setup the constellation network based on the specified configuration with the default Vesrion and Mismatched Host Attribute Checks. It shall configure or create the following resources for the constellation network based on the specifying intent

- Device Config
- Ethernet Port
- Ethernet Port's Attchement Circuit (AC)
- Line Port's Carrier
- Line Port Carrier's Digital Subcriber Carrier (DSCs
- Line Port Carrier's Digital Subcriber Carrier Group (DSCG)
- Device Local Connection (LC)

## Inputs

1. Filters: The device names to be filtered out from the intent. If the constellation is already coonfigured, the filtered devices' resources will be deleted from the network.

```
variable filtered_devices {
  type = list(string)
  default = []
}
```

3. Network: For each device, specify its Device, Device config, its Client Ports and Line Carriers.

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

2. Bandwidth: Specify both Hub and Leaf Bandwidths

   1. Hub Bandwidth: Defines the bandwidth to provisioned between Hub and each leaf. For each leaf, define the Hub DSC ids to be assigned to the BW, and the Hub DSCG id and Leaf DSCG id to be used to create the DSCG. Creates Hub DSCGs.

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

   2. Leaf bandwidth: Defines the bandwidth to provisioned between Hub and each leaf. For each leaf, define the Hub DSC ids to be assigned to the BW, and the Hub DSCG id and Leaf DSCG id to be used to create the DSCG. Creates Leaf DSCGs.

   ```
   variable "leaf_bandwidth" {
     type = map(map(object({ hubdscgid = string, leafdscgid = string, hubdscidlist = list(string), leafdscidlist = list(string), direction = string
     // direction possible values: bidi, us, ds
     })))
   }

   Example:
     leaf_bandwidth = {
       xr-regA_H1-L1 = {
         xr-regA_H1-Hub-BW5173ds = { hubdscgid = "3", leafdscgid = "2", hubdscidlist = ["5"], leafdscidlist = ["1"], direction = "us" }
       }
     }
   ```

3. Services: Defines the local connections for each node in the network. Each conection includes the Cliend id and DSCG id

```
variable "client-2-dscg" {
  type = map(map(object({ clientindex = optional(number) // index to module_clients list
                          dscgaid   = optional(string)
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
      dscgaid   = "1"
      
      capacity = 4
      imc = "MatchAll"
      imc_outer_vid = ""
      emc = "None"
      emc_outer_vid = ""
    },
    lc-xr-regA_H1-L1-1-us = { // hub rcv <- leaf 1, 25G US
      clientindex = 0
      dscgaid   = "3" // US DSCG ID
      lctype = "uniDirUs"
      capacity = 1
      imc = "None"
      imc_outer_vid = ""
      emc = "MatchOuterVID"
      emc_outer_vid = "100"
    }
  }
```

## Outputs :

None. The network is setup.

## Usage

```
// Set up the Constellation Network
module "network" {
  depends_on = [module.network_with_IDs_check]

  source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//tasks/network"

  network = var.network
  leaf_bandwidth = var.leaf_bandwidth
  hub_bandwidth = var.hub_bandwidth
  client-2-dscg     = var.client-2-dscg
  filtered_devices = module.network_with_IDs_check.device_names
}

```

## Usage Reference:

1. [Network Cleanup Device Use Case](https://github.com/infinera/terraform-xr-network/tree/main/use_cases/network_cleanup_device)
2. [Network Device Replacement Workflow](https://github.com/infinera/terraform-infinera-xr-modules/tree/main/workflows/network_device_replacement)
3. [Network Setup Workflow](https://github.com/infinera/terraform-infinera-xr-modules/tree/main/workflows/setup_network)
4. [Network Setup With Checks Workflow](https://github.com/infinera/terraform-infinera-xr-modules/tree/main/workflows/setup_network_with_checks)
