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
  resource_type = "Device"
  filter = "Mismatched"
}

locals {
  resources = module.get_and_filter_checked_resources.resources
  device_names = module.get_and_filter_checked_resources.device_names
  version_mismatched = length(local.device_names) > 0
  device_version_checks_outputs = local.version_mismatched ? [for k,v in local.resources : "Device:${upper(k)}, Device_Version: ${v.devicevalue}, Intent_Version: ${v.intentvalue}"] : []
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
  throw = "Devices with Mismatched Software Version:\n${join("\n", local.device_version_checks_outputs)}\n\n Please upgrade the Device if required. If the SW vesrions are compatible, please set 'assert' to false or remove 'Version' from the 'asserts' list; then run again."
}

output "resources" {
   value = local.resources
}

output "device_names" {
  value = local.device_names
}


