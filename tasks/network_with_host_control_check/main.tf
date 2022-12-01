
terraform {
  required_providers {
    xrcm = {
      source = "infinera.com/poc/xrcm"
    }
  }
}

provider "xrcm" {
  username = "dev"
  password = "xrSysArch3"
  host     = "https://sv-kube-prd.infinera.com:443"
}

module  "get_and_filter_checked_resources"{
  source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//utils/get_and_filter_checked_resources"
  //source = "../../utils/get_and_filter_checked_resources"

  network = var.network
  resource_type = "Ethernet"
  filter = var.condition
}

locals {
  host_control_resources = { for k, v in module.get_and_filter_checked_resources.resources : k => v if length(v) > 0}
  host_control = length(local.host_control_resources) > 0
  host_control_checks_outputs = local.host_control ? [for k,v in local.host_control_resources : "Module:${upper(k)}, resources: ${jsonencode(v)}"] : []
  device_names = local.host_control ? [for k,v in local.host_control_resources : k ] : []
  upper_device_names = [for k in local.device_names : "${upper(k)}"]
}

output "message" {
  value = local.host_control && !var.assert ? "Not Assert. Devices with <<${var.condition}>> attributes:\n${join("\n", local.host_control_checks_outputs)}\n\nAction: Continue to run" : ""
}

output "resources" {
  value = local.host_control_resources
}

// check module with mismatched version
data "xrcm_check" "check_host_control" {
  depends_on = [module.get_and_filter_checked_resources] 

  count = var.assert ? 1 : 0
  condition = local.host_control
  description = "Devices with <<${var.condition}>> attributes: ${join(":::", local.upper_device_names)}"
  throw = "Devices with <<${var.condition}>> attributes:\n${join("\n", local.host_control_checks_outputs)}\n\nHost controlled and mismatched attributes can not be updated by IPM.\nTo continue the run for other devices which has no <<${var.condition}>> condition; please set 'assert' to false"
}

// Set up the Constellation Network
/*module "network" {
  depends_on = [data.xrcm_check.check_host_control]

  source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//tasks/network"
  //source = "../network"

  network = var.network
  leaf_bandwidth = var.leaf_bandwidth
  hub_bandwidth = var.hub_bandwidth
  client-2-dscg     = var.client-2-dscg
}*/


