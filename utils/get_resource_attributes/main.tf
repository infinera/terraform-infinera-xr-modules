terraform {
  required_providers {
    xrcm = {
      source = "infinera.com/poc/xrcm"
    }
  }
}

data "xrcm_check_resources" "checked_attributes" {
  queries =  length(var.resource_type) > 0 ? [ for k,v in var.network.setup: { n = k, resourcetype = var.resource_type, resources = [ for client in v["moduleclients"]: {resourceid = client.clientid, attributevalues = [{ attribute = "portSpeed", intentvalue = client.portspeed, controlattribute = "portSpeedControl"}]} ] } ] : []
}

locals {
  depends_on = [data.xrcm_check_resources.checked_attributes]
  devices_attributes = var.filter == "HostAttributeNMismatched" ? {for config in data.xrcm_check_resources.checked_attributes.queries: config.n => flatten([ for res in config.resources : [for attributevalue in res.attributevalues : merge({ resourceid =  res.resourceid, resourcetype = config.resourcetype}, attributevalue) if ( attributevalue.isvaluematch == false && attributevalue.attributecontrolbyhost == true ) ] ]) }  : var.filter == "HostAttribute" ? {for config in data.xrcm_check_resources.checked_attributes.queries: config.n => flatten([ for res in config.resources : [for attributevalue in res.attributevalues : merge({ resourceid =  res.resourceid, resourcetype = config.resourcetype}, attributevalue) if ( attributevalue.attributecontrolbyhost == true ) ] ]) } : var.filter == "Mismatched" ?  {for config in data.xrcm_check_resources.checked_attributes.queries: config.n => flatten([ for res in config.resources : [for attributevalue in res.attributevalues : merge({ resourceid =  res.resourceid, resourcetype = config.resourcetype}, attributevalue) if ( attributevalue.isvaluematch == false ) ] ]) } : var.filter == "HostAttributeNMatched" ?  {for config in data.xrcm_check_resources.checked_attributes.queries: config.n => flatten([ for res in config.resources : [for attributevalue in res.attributevalues : merge({ resourceid =  res.resourceid, resourcetype = config.resourcetype}, attributevalue) if ( attributevalue.isvaluematch == true && attributevalue.attributecontrolbyhost == true ) ] ]) } : var.filter == "NonHostAttributeNMismatched" ?  {for config in data.xrcm_check_resources.checked_attributes.queries: config.n => flatten([ for res in config.resources : [for attributevalue in res.attributevalues : merge({ resourceid =  res.resourceid, resourcetype = config.resourcetype}, attributevalue) if ( attributevalue.isvaluematch == false && attributevalue.attributecontrolbyhost == false ) ] ]) } : var.filter == "NonHostAttributeNMatched" ?  {for config in data.xrcm_check_resources.checked_attributes.queries: config.n => flatten([ for res in config.resources : [for attributevalue in res.attributevalues : merge({ resourceid =  res.resourceid, resourcetype = config.resourcetype}, attributevalue) if ( attributevalue.isvaluematch == true && attributevalue.attributecontrolbyhost == false ) ] ]) } : {}
  device_names = [for k,v  in local.devices_attributes : upper("${k}") if length(v) > 0]
}

output "checked_attributes" {
  value = data.xrcm_check_resources.checked_attributes
}

output devices_attributes {
  value = local.devices_attributes
}
