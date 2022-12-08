# Setup Network Module
This module will setup the constellation network based on the specified configuration with the default Vesrion and Mismatched Host Attribute Checks
## How to Run 
  1. Go to the **network** directory or its clone directory
     1. Assumption: *terraform init* was executed before (only one time) to initialize the terraform setup.
  2. Specify the input variables by updating the *AAA.auto.tfvars* input file. 
     1. The network intent
     2. The bandwidth intent
     3. The sevice intent
     4. The filtered_devices (Optional)
  3. Execute *terraform apply* to run using the input from *AAA.auto.tfvars* or *terraform -apply -var-file="AAA.tfvars"*. This will configure the constellation network with the specified asserted conditions

*main.tf* in **network** directory
```
data "xrcm_detaildevices" "onlineleafdevices" {
  names = [for k,v in var.network.setup: k if v.deviceconfig["configuredrole"] == "leaf"]
  state = "ONLINE"
}

locals {
  hub_names = length(var.filtered_devices) > 0 ? setsubtract(data.xrcm_detaildevices.onlinehubdevices.devices == null ? [] : [for onlinedevice in data.xrcm_detaildevices.onlinehubdevices.devices : onlinedevice.name], var.filtered_devices) : data.xrcm_detaildevices.onlinehubdevices.devices == null ? [] : [for onlinedevice in data.xrcm_detaildevices.onlinehubdevices.devices : onlinedevice.name]
  leaf_names = length(var.filtered_devices) > 0 ? setsubtract(data.xrcm_detaildevices.onlineleafdevices.devices == null ? [] : [for onlinedevice in data.xrcm_detaildevices.onlineleafdevices.devices : onlinedevice.name], var.filtered_devices) : data.xrcm_detaildevices.onlineleafdevices.devices == null ? [] : [for onlinedevice in data.xrcm_detaildevices.onlineleafdevices.devices : onlinedevice.name]
  module_carriers = { for k,v in var.network.setup: k => v.devicecarriers[0]}
  module_clients =  { for k,v in var.network.setup: k => v.deviceclients }
}

module "network-setup" {
  source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//network_setup"
  //source = "../../network-setup"

  hub_names = local.hub_names  
  leaf_names = local.leaf_names
  trafficmode = var.network.configs.trafficmode
}

module "bandwidth-setup" {
  depends_on        = [module.network-setup]
  source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//bandwidth_setup"
  //source = "../../bandwidth-setup"
  hub_names = local.hub_names
  leaf_names = local.leaf_names
  leaf_bandwidth = var.leaf_bandwidth // specify the intent Leaf bandwidth
  hub_bandwidth = var.hub_bandwidth   specify the intent Hub bandwidth
  trafficmode = var.network.configs.trafficmode
  module_carriers = local.module_carriers
}

module "service-setup" {
  depends_on        = [module.bandwidth-setup]
  source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//service_setup"
  //source = "../../service-setup"
  hub_names = local.hub_names
  leaf_names = local.leaf_names
  client-2-dscg     = var.client-2-dscg
  trafficmode = var.network.configs.trafficmode
  module_carriers = local.module_carriers
  module_clients = local.module_clients
}

```
## Usage: Use Case - [Network Cleanup Device](https://github.com/infinera/terraform-xr-network/tree/main/use_cases/network_cleanup_device)
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


