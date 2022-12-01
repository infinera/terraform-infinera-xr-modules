
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
  resources = module.get_and_filter_checked_resources.resources
  device_names = module.get_and_filter_checked_resources.device_names
  host_control = length(local.device_names) > 0
  host_control_checks_outputs = local.host_control ? [for k,v in local.resources : "Module:${upper(k)}, resources: ${jsonencode(v)}"] : []
  upper_device_names = [for k in local.device_names : "${upper(k)}"]
}

output "message" {
  value = local.host_control && !var.assert ? "Not Assert. Devices with <<${var.condition}>> attributes:\n${join("\n", local.host_control_checks_outputs)}\n\nAction: Continue to run" : ""
}

// check module with mismatched version
data "xrcm_check" "check_host_control" {
  depends_on = [module.get_and_filter_checked_resources] 

  count = var.assert ? 1 : 0
  condition = local.host_control
  description = "Devices with <<${var.condition}>> attributes: ${join(":::", local.upper_device_names)}"
  throw = "Devices with <<${var.condition}>> attributes:\n${join("\n", local.host_control_checks_outputs)}\n\nHost attributes can not be updated by IPM.\nTo continue the run for other devices which has no configuration on Host attributes; please set 'assert' to false"
}

output "resources" {
   value = local.resources
}

output "device_names" {
  value = local.device_names
}




