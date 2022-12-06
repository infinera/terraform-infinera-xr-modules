
module  "get_devices_with_different_ids"{
  source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//utils/get_devices_with_different_ids"
  //source = "../../utils/get_devices_with_different_ids"

  device_names = [for k,v in var.network.setup: k]
  state = "ONLINE"
}

locals {
  devices = module.get_devices_with_different_ids.devices
  ids_mismatched = local.devices != null ? length(local.devices) > 0 : false
  deviceid_checks_outputs = local.ids_mismatched ? [for k,v in local.devices : "Module:${upper(k)}, DeviceID: ${v.network_deviceid}, tfstateDeviceID: ${v.tfstate_deviceid}"] : []
  device_names = local.ids_mismatched ? [for k,v in local.devices : k ] : []
  upper_device_names = [for k in local.device_names : upper("${k}")]
}

output "message" {
  value = local.ids_mismatched && !var.assert ? "Not Assert. ID(s) Mismatched:\n${join("\n", local.deviceid_checks_outputs)}\n\nAction: Continue to run with filtering the mismatched devices listed above" : ""
}

// check module with same name but ID is diff
data "xrcm_check" "check_deviceid_mismatched" {
  depends_on = [module.get_devices_with_different_ids] 

  count = var.assert ? 1 : 0
  condition = local.ids_mismatched
  description = "Devices ids are mismatched: ${join(", ", local.upper_device_names)}"
  throw = "ID(s) Mismatched:\n${join("\n", local.deviceid_checks_outputs)}"
}

output "devices" {
   value = local.devices
}

output "deviceid_checks_outputs" {
   value = local.ids_mismatched ? local.deviceid_checks_outputs : []
}

output "device_names" {
  value = local.device_names
}


