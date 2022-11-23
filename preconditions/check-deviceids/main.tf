terraform {
  required_providers {
    xrcm = {
      source = "infinera.com/poc/xrcm"
    }
  }
}

module  "get_devices_with_different_ids" {
  source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//utils/get_devices_with_different_ids"
  //source = "../../../terraform-infinera-xr-modules/utils/get_devices_with_different_ids"

  device_names = ["xr-regA_H1-L1", "xr-regA_H1-Hub", "xr-regA_H1-2", "xr-regA_H1-4"]
  state = "ONLINE"
  devices_file = var.devices_file
  save_file = true //var.save_file
}

locals {
  deviceid_checks = module.get_devices_with_different_ids.devices
  deviceid_checks_outputs = local.deviceid_checks != null ? [for k,v in local.deviceid_checks : "Module:${upper(k)}, SavedID:${v.saved_deviceid}, NetworkID:${v.network_deviceid}"] : []
  device_names = local.deviceid_checks != null ? [for k,v in local.deviceid_checks : upper("${k}")] : []
}

// check module with same name but ID is diff
data "xrcm_check" "check_deviceid_mismatched" {
  depends_on = [module.get_devices_with_different_ids]
  condition = local.deviceid_checks != null && length(local.deviceid_checks) > 0
  description = "Devices ids are mismatched: ${join(", ", local.device_names)}"
  throw = "ID(s) Mismatched:\n${join("\n", local.deviceid_checks_outputs)}"
}


