# Terraform Set Up Network Module
This module shall create a constellation network without any check or filtered devices

## How to
The procedure to replace one device by another device shall involve two steps
  1. Go to the **setup_network** directory or its clone directory
     1. Assumption: *terraform init* was executed before (only one time) to initialize the terraform setup.
  2. Specify the input variables by updating the **AAA.auto.tfvars** input file. 
     1. The network intent
     2. The bandwidth intent
     3. The sevice intent
  3. Execute *terraform apply* to run using the input from *AAA.auto.tfvars* or *terraform -apply -var-file="AAA.tfvars"*. This will create the constellation network.

*main.tf* in **setup_network** directory
```
  // network module shall provision the constellation network without any checks
  module "network" {
    source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//tasks/network"
    //source = "source = "../../tasks/network"

    network = var.network                       // specify the intent network
    leaf_bandwidth = var.leaf_bandwidth         // specify the intent leaf bandwidth
    hub_bandwidth = var.hub_bandwidth           // specify the intent Hub bandwidth
    client-2-dscg     = var.client-2-dscg       // specify the intent service (AC and/or LC)
}
```
## Description
Below is the run sequence
### Set up constellation configuration
1. Configure Network
   1. Configure Hub Device Config
   2. Configure Leaf Device Config
   3. Configure Hub Device Carrier
   4. Configure Leaf Device Carrier
2. Configure Bandwidth
   1. Configure Hub Device DSC
   2. Configure Leaf Device DSC
   3. Configure Hub Device DSCG
   4. Configure Leaf Device DSCG
   5. Configure Leaf Device DSCG-Hub
3. Provision Service
   1. Provision Hub Device AC
   2. Provision Leaf Device AC
   3. Provision Hub Device LC
   4. Provision Leaf Device LC
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
### Bandwidth: Specify both Hub and Leaf Bandwidths
#### Hub Bandwidth: Defines the bandwidth to provisioned between Hub and each leaf. For each leaf, define the Hub DSC ids to be assigned to the BW, and the Hub DSCG id and Leaf DSCG id to be used to create the DSCG. Creates Hub DSCGs.
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
### Leaf bandwidth: Defines the bandwidth to provisioned between Hub and each leaf. For each leaf, define the Hub DSC ids to be assigned to the BW, and the Hub DSCG id and Leaf DSCG id to be used to create the DSCG. Creates Leaf DSCGs.
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
### Services: Defines the local connections for each node in the network. Each conection includes the Cliend id and DSCG id
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