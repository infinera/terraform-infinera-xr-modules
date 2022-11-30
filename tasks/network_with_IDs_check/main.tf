
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

// This module initializes the:
// network
// bandwidht
// service
module  "get_devices_with_different_ids"{
  source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//utils/get_devices_with_different_ids"
  //source = "../../utils/get_devices_with_different_ids"

  device_names = [for k,v in var.network.setup: k]
  state = "ONLINE"
  devices_file = var.devices_file
  save_file = false //var.save_file
}

locals {
  ids_mismatched_devices = module.get_devices_with_different_ids.devices
  ids_mismatched = length(local.ids_mismatched_devices) > 0
  deviceid_checks_outputs = local.ids_mismatched ? [for k,v in local.ids_mismatched_devices : "Module:${upper(k)}, SavedID: ${v.saved_deviceid}, DeviceID: ${v.network_deviceid}"] : []
  device_names = local.ids_mismatched != null ? [for k,v in local.ids_mismatched_devices : k ] : []
  upper_device_names = [for k in local.device_names : upper("${k}")]
}

module "print_message" {
    //source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//utils/print_message"
    source = "../../utils/print_message"

    count = local.ids_mismatched ? 1 : 0
    title = upper("Devices with Mismatched IDs")
    message = "ID(s) Mismatched:\n${join("\n", local.deviceid_checks_outputs)}"
}

output "message" {
  value = local.ids_mismatched && !var.assert ? "Not Assert. ID(s) Mismatched:\n${join("\n", local.deviceid_checks_outputs)}\n\nAction: Continue to run with filtering the mismatched devices listed above" : ""
}

// check module with same name but ID is diff
data "xrcm_check" "check_deviceid_mismatched" {
  depends_on = [module.get_devices_with_different_ids.hubs, module.get_devices_with_different_ids.leafs] //, module.print_message]

  count = var.assert ? 1 : 0
  condition = local.ids_mismatched
  description = "Devices ids are mismatched: ${join(", ", local.upper_device_names)}"
  throw = "ID(s) Mismatched:\n${join("\n", local.deviceid_checks_outputs)}"
}

// Set up the Constellation Network
module "network" {
  depends_on = [data.xrcm_check.check_deviceid_mismatched]

  source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//tasks/network"
  //source = "../network"

  network = var.network
  leaf_bandwidth = var.leaf_bandwidth
  hub_bandwidth = var.hub_bandwidth
  client-2-dscg     = var.client-2-dscg
  filtered_devices = local.device_names
}


