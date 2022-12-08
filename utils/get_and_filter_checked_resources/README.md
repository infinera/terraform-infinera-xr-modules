# Util: get_and_filter_checked_resources

## How to Run 
  1. Go to the **get_and_filter_checked_resources** directory or its clone directory
     1. Assumption: *terraform init* was executed before (only one time) to initialize the terraform setup.
  2. Specify the input variables by updating the *AAA.auto.tfvars* input file. 
     1. The network intent
  3. Execute *terraform apply* to run using the input from *AAA.auto.tfvars* or *terraform -apply -var-file="AAA.tfvars"*. 

*main.tf* in **get_and_filter_checked_resources** directory
```
locals {
  queries = length(var.queries) > 0  ? [for query in var.queries: query] : var.resource_type == "Ethernet" ? [ for k,v in var.network.setup: { n = k, resourcetype = var.resource_type, resources = [ for client in v["deviceclients"]: {grandparentid = "", parentid = "", resourceid = client.clientid, attributevalues = [{ attribute = "portSpeed", intentvalue = client.portspeed, controlattribute = "portSpeedControl"}]} ] } ] : var.resource_type == "Carrier" ? [ for k,v in var.network.setup: { n = k, resourcetype = "Carrier", resources = [ for carrier in v["devicecarriers"]: {grandparentid = "", parentid = carrier.lineptpid, resourceid = carrier.carrierid, attributevalues = [{ attribute = "modulation", intentvalue = carrier.modulation, controlattribute = "modulationControl"}]} ] } ] : var.resource_type == "Config" ? [ for k,v in var.network.setup: { n = k, resourcetype = "Config", resources = [{grandparentid = "", parentid = "", resourceid = k, attributevalues = [{ attribute = "trafficMode", intentvalue = v["deviceconfig"].trafficmode, controlattribute = "trafficModeControl"}]} ] } ] : var.resource_type == "Device" ? [ for k,v in var.network.setup: { n = k, resourcetype = "Device", resources = [{grandparentid = "", parentid = "", resourceid = k, attributevalues = [{attribute = "sv", intentvalue = v["device"].sv}]} ] } ]: []
}

data "xrcm_check_resources" "resources" {
  queries =  local.queries
}

module "filter_checked_resources" {
  source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//utils/filter_checked_resources"
  //source = "../filter_checked_resources"
  filter = var.filter
  devices_resources = data.xrcm_check_resources.resources.queries
}

output "resources" {
  value = module.filter_checked_resources.resources
}

output device_names {
  value = module.filter_checked_resources.device_names
}
```
## Usage: Utils [get_and_filter_checked_resources](https://github.com/infinera/terraform-infinera-xr-modules/tree/main/utils/get_and_filter_checked_resources)
## Description

## Inputs
