terraform {
  required_providers {
    xrcm = {
      source = "infinera.com/poc/xrcm"
    }
  }
}

module  "get_and_filter_checked_resources"{
  source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//utils/get_and_filter_checked_resources"
  //source = "../../utils/get_and_filter_checked_resources"

  network = var.network
  resource_type = "Ethernet"
  filter = "HostAttributeNMismatched"
}

locals {
  resources = module.get_and_filter_checked_resources.resources
  device_names = module.get_and_filter_checked_resources.device_names
  host_control = length(local.device_names) > 0
  mismatched_host_attribute_check_outputs = local.host_control ? [for k,v in local.resources : "Module:${upper(k)}, resources: ${jsonencode(v)}"] : []
  upper_device_names = [for k in local.device_names : "${upper(k)}"]
}

output "message" {
  value = local.host_control && !var.assert ? "Not Assert. Devices with <<HostAttributeNMismatched>> attributes:\n${join("\n", local.mismatched_host_attribute_check_outputs)}\n\nAction: Continue to run" : ""
}

// check module with mismatched host attributes
data "xrcm_check" "check_mismatched_host_attribute" {
  depends_on = [module.get_and_filter_checked_resources] 

  count = var.assert ? 1 : 0
  condition = local.host_control
  description = "Devices with <<HostAttributeNMismatched>> attributes: ${join(":::", local.upper_device_names)}"
  throw = "Devices with <<HostAttributeNMismatched>> attributes:\n${join("\n", local.mismatched_host_attribute_check_outputs)}\n\nHost attributes can not be updated by IPM.\nTo continue the run for other devices which has no conflict>> condition; please set 'assert' to false or remove the <<HostAttributeNMismatched>> from 'asserts' list. "
}

output "resources" {
   value = local.resources
}

output "mismatched_host_attribute_check_outputs" {
   value = local.mismatched_host_attribute_check_outputs
}

output "device_names" {
  value = local.device_names
}




