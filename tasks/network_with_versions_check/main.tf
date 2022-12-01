
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
  resource_type = "Device"
  filter = "Mismatched"
}

locals {
  vesrion_mismatched_resources = module.get_and_filter_checked_resources.resources
  device_names = module.get_and_filter_checked_resources.device_names
  version_mismatched = length(local.device_names) > 0
  device_version_checks_outputs = local.version_mismatched ? [for k,v in local.vesrion_mismatched_resources : "Module:${upper(k)}, resources: ${jsonencode(v)}"] : []
  upper_device_names = [for k in local.device_names : "${upper(k)}"]
}

output "message" {
  value = local.version_mismatched && !var.assert ? "Not Assert. Devices with Mismatched Version:\n${join("\n", local.device_version_checks_outputs)}\n\nAction: Continue to run" : ""
}

// check module with mismatched version
data "xrcm_check" "check_device_version_mismatched" {
  depends_on = [module.get_and_filter_checked_resources] 

  count = var.assert ? 1 : 0
  condition = local.version_mismatched
  description = "Devices's version are mismatched: ${join(":::", local.upper_device_names)}"
  throw = "Devices with Mismatched Software Version:\n${join("\n", local.device_version_checks_outputs)}\n\n Please upgrade the Device if required or set 'assert' to false then run again."
}

// Set up the Constellation Network
module "network" {
  depends_on = [data.xrcm_check.check_device_version_mismatched]

  source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//tasks/network"
  //source = "../network"

  network = var.network
  leaf_bandwidth = var.leaf_bandwidth
  hub_bandwidth = var.hub_bandwidth
  client-2-dscg     = var.client-2-dscg
}


