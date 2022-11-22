/*terraform {
  required_providers {
    xrcm = {
      source = "infinera.com/poc/xrcm"
    }
  }
}*/

data "xrcm_devices" "devices" {
  names = var.device_names 
  state = var.state
  save = var.save
}

locals {
 devices  = fileexists("${var.devices_file}") ? jsondecode(file("${var.devices_file}")) : null
}

locals {
  deviceid_checks = local.devices != null ? {for device in data.xrcm_devices.devices.devices: device.n => {olddeviceid = local.devices[device.n].DeviceId, newdeviceid = device.deviceid} if device.deviceid != local.devices[device.n].DeviceId } : null
  deviceid_checks_outputs = local.deviceid_checks != null ? [for k,v in local.deviceid_checks : "name:${upper(k)}, old:${v.olddeviceid}, new:${v.newdeviceid}"] : []
  device_names = local.deviceid_checks != null ? [for k,v in local.deviceid_checks : upper("${k}")] : []
}

// check module with same name but ID is diff
data "xrcm_check" "check_deviceid_mismatched" {
  depends_on        = [data.xrcm_devices.devices]
  condition = local.deviceid_checks != null && length(local.deviceid_checks) > 0
  description = "Check devices ids mismatched: ${join(",", local.device_names)}"
  throw = "ID(s) Mismatched:\n${join("\n", local.deviceid_checks_outputs)}"
}


