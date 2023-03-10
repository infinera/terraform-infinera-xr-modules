terraform {
  required_providers {
    xrcm = {
      source = "infinera.com/poc/xrcm"
    }
  }
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
data "xrcm_check_resources" "checked_resources" {
  queries = length(var.queries) > 0 ? [for query in var.queries : query] : var.resource_type == "Ethernet" ? [for k, v in var.network.setup : { n = k, resourcetype = var.resource_type, resources = [for client in v["deviceclients"] : { grandparentid = "", parentid = "", resourceid = client.clientaid, attributevalues = [{ attribute = "portSpeed", intentvalue = client.portspeed, controlattribute = "portSpeedControl" }] }] }] : var.resource_type == "Carrier" ? [for k, v in var.network.setup : { n = k, resourcetype = "Carrier", resources = [for carrier in v["devicecarriers"] : { grandparentid = "", parentid = carrier.lineptpid, resourceid = carrier.carrierid, attributevalues = [{ attribute = "modulation", intentvalue = carrier.modulation, controlattribute = "modulationControl" }] }] }] : var.resource_type == "Config" ? [for k, v in var.network.setup : { n = k, resourcetype = "Config", resources = [{ grandparentid = "", parentid = "", resourceid = k, attributevalues = [{ attribute = "trafficMode", intentvalue = v["deviceconfig"].trafficmode, controlattribute = "trafficModeControl" }] }] }] : var.resource_type == "Device" ? [for k, v in var.network.setup : { n = k, resourcetype = "Device", resources = [{ grandparentid = "", parentid = "", resourceid = k, attributevalues = [{ attribute = "di", intentvalue = v["device"].di }, { attribute = "st", intentvalue = v["device"].st }] }] }] : []
}

/* List of checked resource (ResourceDataSourceData)
   
   list(object({ n= string, resourcetype = string, 
                 resources = list(object({resourceid = string, attributevalues = string, controlattribute = string, parentid= optional(string)
                                          parentid= optional(string), grandparentid = optional(string)})) }))
*/

output "checked_resources" {
  value = data.xrcm_check_resources.checked_resources.queries
}

