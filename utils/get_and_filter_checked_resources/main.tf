terraform {
  required_providers {
    xrcm = {
      source = "infinera.com/poc/xrcm"
    }
  }
}

// Generate a queries input for data source xrcm_check_resources.
locals {
  queries = length(var.queries) > 0 ? [for query in var.queries : query] : var.resource_type == "Ethernet" ? [for k, v in var.network.setup : { n = k, resourcetype = var.resource_type, resources = [for client in v["deviceclients"] : { grandparentid = "", parentid = "", resourceid = client.clientaid, attributevalues = [{ attribute = "portSpeed", intentvalue = client.portspeed, controlattribute = "portSpeedControl" }] }] }] : var.resource_type == "Carrier" ? [for k, v in var.network.setup : { n = k, resourcetype = "Carrier", resources = [for carrier in v["devicecarriers"] : { grandparentid = "", parentid = carrier.lineptpid, resourceid = carrier.carrierid, attributevalues = [{ attribute = "modulation", intentvalue = carrier.modulation, controlattribute = "modulationControl" }] }] }] : var.resource_type == "Config" ? [for k, v in var.network.setup : { n = k, resourcetype = "Config", resources = [{ grandparentid = "", parentid = "", resourceid = k, attributevalues = [{ attribute = "trafficMode", intentvalue = v["deviceconfig"].trafficmode, controlattribute = "trafficModeControl" }] }] }] : var.resource_type == "Device" ? [for k, v in var.network.setup : { n = k, resourcetype = "Device", resources = [{ grandparentid = "", parentid = "", resourceid = k, attributevalues = [{ attribute = "sv", intentvalue = v["device"].sv }] }] }] : []
}

/* Get all the devices'resources data source based on the intent and specify resource Type (condition)
  The data source xrcm_check_resources expects the inputs below

  // Use tfsdk attribute name in terraform

    queries = []ResourceDataSourceData `tfsdk:"queries"`

  type ResourceDataSourceData struct {
    N         types.String    `tfsdk:"n"`
    DeviceId  types.String    `tfsdk:"deviceid"`
    ResourceType types.String `tfsdk:"resourcetype"`
    Resources []ResourceData  `tfsdk:"resources"`
  }
  
  type ResourceData struct {
    Id              types.String          `tfsdk:"id"`
    GrandparentId   types.String          `tfsdk:"grandparentid"`
    ParentId        types.String          `tfsdk:"parentid"`
    ResourceId      types.String          `tfsdk:"resourceid"`
    Aid             types.String          `tfsdk:"aid"`
    AttributeValues []AttributeValuesData `tfsdk:"attributevalues"`
  }

  type AttributeValuesData struct {
    Attribute              types.String `tfsdk:"attribute"`
    IntentValue            types.String `tfsdk:"intentvalue"`
    DeviceValue            types.String `tfsdk:"devicevalue"`
    ControlAttribute       types.String `tfsdk:"controlattribute"`
    IsValueMatch           types.Bool   `tfsdk:"isvaluematch"`
    AttributeControlByHost types.Bool   `tfsdk:"attributecontrolbyhost"`
  }
*/
data "xrcm_check_resources" "resources" {
  queries = local.queries
}

// Get only the checked resources which meet the specify filter (condition)
module "filter_checked_resources" {
  source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//utils/filter_checked_resources"
  //source = "../filter_checked_resources"
  filter            = var.filter
  devices_resources = data.xrcm_check_resources.resources.queries
}

// The devices'resources which meet the condition. It is a map of device name to the array of its matched resources.
// The resource is a object as shown below
// object ({ n= string, resourcetype = string, deviceid = optional(string)
//   resources = list(object({resourceid = string, attributevalues = string, controlattribute = optional(string), parentid= optional(string), 
//   grandparentid = optional(string), attributevalues = optional(list(object({attribute=string, intentvalue= string, devicevalue=optional(string),
//   controlattribute= optional(string),isvaluematch=optional(bool), attributecontrolbyhost = optional(bool)}
output "resources" {
  value = module.filter_checked_resources.resources
}

// The list of device names which has attributes met the condition
output "device_names" {
  value = module.filter_checked_resources.device_names
}
