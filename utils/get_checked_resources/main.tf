

data "xrcm_check_resources" "checked_resources" {
  queries =  length(var.queries) > 0  ? [for query in var.queries: query] : var.resource_type == "Ethernet" ? [ for k,v in var.network.setup: { n = k, resourcetype = var.resource_type, resources = [ for client in v["deviceclients"]: {grandparentid = "", parentid = "", resourceid = client.clientid, attributevalues = [{ attribute = "portSpeed", intentvalue = client.portspeed, controlattribute = "portSpeedControl"}]} ] } ] : var.resource_type == "Carrier" ? [ for k,v in var.network.setup: { n = k, resourcetype = "Carrier", resources = [ for carrier in v["devicecarriers"]: {grandparentid = "", parentid = carrier.lineptpid, resourceid = carrier.carrierid, attributevalues = [{ attribute = "modulation", intentvalue = carrier.modulation, controlattribute = "modulationControl"}]} ] } ] : var.resource_type == "Config" ? [ for k,v in var.network.setup: { n = k, resourcetype = "Config", resources = [{grandparentid = "", parentid = "", resourceid = k, attributevalues = [{ attribute = "trafficMode", intentvalue = v["deviceconfig"].trafficmode, controlattribute = "trafficModeControl"}]} ] } ] : var.resource_type == "Device" ? [ for k,v in var.network.setup: { n = k, resourcetype = "Device", resources = [{grandparentid = "", parentid = "", resourceid = k, attributevalues = [{attribute = "di", intentvalue = v["device"].di}, {attribute = "st", intentvalue = v["device"].st}]} ] } ]: []
}

output "checked_resources" {
  value = data.xrcm_check_resources.checked_resources.queries
}

