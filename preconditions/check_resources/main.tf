terraform {
  required_providers {
    xrcm = {
      source = "infinera.com/poc/xrcm"
    }
  }
}

data "xrcm_check_resources" "check_ethernets" {
  queries = [ for k,v in var.network.setup: { n = k, resourcetype = "Ethernet", resources = [ for client in v["moduleclients"]: {resourceid = client.clientid, attributevalues = [{ attribute = "portSpeed", intentvalue = client.portspeed, controlattribute = "portSpeedControl"}]} ] } ]
}

data "xrcm_check_resources" "check_configs" {
  queries = [ for k,v in var.network.setup: { n = k, resourcetype = "Config", resources = [{resourceid = k, attributevalues = [{ attribute = "trafficMode", intentvalue = v["moduleconfig"].trafficmode, controlattribute = "trafficModeControl"}]} ] } ]
}

data "xrcm_check_resources" "check_carriers" {
  queries = [ for k,v in var.network.setup: { n = k, resourcetype = "Carrier", resources = [ for carrier in v["modulecarriers"]: {resourceid = carrier.carrierid, parentid = carrier.lineptpid,attributevalues = [{ attribute = "modulation", intentvalue = carrier.modulation, controlattribute = "modulationControl"}]} ] } ]
}

locals {
  depends_on = [data.xrcm_check_resources.check_configs]
  hostconfigs = {for config in data.xrcm_check_resources.check_configs.queries: config.n => flatten([ for res in config.resources : [for attributevalue in res.attributevalues : merge({ resourceid =  res.resourceid, resourcetype = config.resourcetype}, attributevalue) if (attributevalue.attributecontrolbyhost == true && attributevalue.isvaluematch == false)] ]) }
  hostethernets = {for ethernet in data.xrcm_check_resources.check_ethernets.queries: ethernet.n => flatten([ for res in ethernet.resources : [for attributevalue in res.attributevalues : merge({ resourceid =  res.resourceid, resourcetype = ethernet.resourcetype}, attributevalue) if (attributevalue.attributecontrolbyhost == true && attributevalue.isvaluematch == false)] ]) }
  hostcarriers =  {for carrier in data.xrcm_check_resources.check_carriers.queries: carrier.n => flatten([ for res in carrier.resources : [for attributevalue in res.attributevalues : merge({ resourceid =  res.resourceid, parentid =  res.parentid, resourcetype = carrier.resourcetype}, attributevalue) if (attributevalue.attributecontrolbyhost == true && attributevalue.isvaluematch == false)] ]) }
  hostconfigs_device_names = [for k,v  in local.hostconfigs : upper("${k}") if length(v) > 0]
  hostethernets_device_names = [for k,v  in local.hostethernets : upper("${k}") if length(v) > 0]
  hostcarriers_device_names = [for k,v  in local.hostcarriers : upper("${k}") if length(v) > 0]
}

output hostconfigs {
  value = local.hostconfigs
}

output hostethernets {
  value = local.hostethernets
}

output hostcarriers {
  value = local.hostcarriers
}

output hostconfigs_device_names {
  value = local.hostconfigs_device_names
}

output hostethernets_device_names {
  value = local.hostethernets_device_names
}

output hostcarriers_device_names {
  value = local.hostcarriers_device_names
}

// check if module config attributes are controlled by host or not
data "xrcm_checks" "check_resources" {
  checks = [
    {
      condition = length(local.hostconfigs_device_names) > 0
      description = "Check if Devices' config Traffic Mode is different and controlled by Host: ${join(",", local.hostconfigs_device_names)}"
      throw = "These Module Configs are different and controlled by Host: Can't configure unless IPM is the controller.\n ${jsonencode(local.hostconfigs)}"
    },
    {
      condition = length(local.hostethernets_device_names) > 0
      description = "Check if Ethernet Port's Speed is different and controlled by Host: ${join(",", local.hostethernets_device_names)}"
      throw = "These Ethernets' attributes are different and controlled by Host: Can't configure unless IPM is the controller.\n ${jsonencode(local.hostethernets)}"
    },
    {
      condition = length(local.hostcarriers_device_names) > 0
      description = "Check if Carrier Modulation is different and controlled by Host: ${join(",", local.hostcarriers_device_names)}"
      throw = "These Ethernets' attributes are different andcontrolled by Host: nCan't configure unless IPM is the controller.\n ${jsonencode(local.hostcarriers)}"
    },
  ]
}

