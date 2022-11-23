data "xrcm_devices" "devices" {
  names = var.device_names 
  state = var.state
  save = var.save_file
}

locals {
 devices  = fileexists("${var.devices_file}") ? jsondecode(file("${var.devices_file}")) : null
}

locals {
  deviceid_checks = local.devices != null ? {for device in data.xrcm_devices.devices.devices: device.n => {saved_deviceid = local.devices[device.n].DeviceId, network_deviceid = device.deviceid} if device.deviceid != local.devices[device.n].DeviceId } : null
}

output "devices" {
  value = local.deviceid_checks
}



