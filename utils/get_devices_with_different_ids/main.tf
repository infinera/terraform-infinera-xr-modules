
data "xrcm_tfstate_devices_ids" "devices_ids" {  }

data "xrcm_devices" "devices" {
  names = var.device_names 
  state = var.state
}

locals {
 devices  = data.xrcm_tfstate_devices_ids.devices_ids.device_ids != null ? {for device in data.xrcm_tfstate_devices_ids.devices_ids.device_ids : device.n => device} : null
}


locals {
  deviceid_checks = local.devices != null ? {for device in data.xrcm_devices.devices.devices: device.n => {tfstate_deviceid = local.devices[device.n].id, network_deviceid = device.deviceid} if device.deviceid != local.devices[device.n].id } : null
}

output "devices" {
  value = local.deviceid_checks
}



