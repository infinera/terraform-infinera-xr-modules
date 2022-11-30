
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
  ids_mismatched = local.ids_mismatched_devices !=  null
  deviceid_checks_outputs = local.ids_mismatched ? [for k,v in local.ids_mismatched_devices : "Module:${upper(k)}, SavedID:${v.saved_deviceid}, NetworkID:${v.network_deviceid}"] : []
  device_names = local.ids_mismatched != null ? [for k,v in local.ids_mismatched_devices : upper("${k}")] : []
}

// check module with same name but ID is diff
data "xrcm_check" "check_deviceid_mismatched" {
  depends_on = [module.get_devices_with_different_ids.hubs, module.get_devices_with_different_ids.leafs]

  count = var.assert ? 1 : 0
  condition = local.ids_mismatched
  description = "Devices ids are mismatched: ${join(", ", local.device_names)}"
  throw = "ID(s) Mismatched:\n${join("\n", local.deviceid_checks_outputs)}"
}

// Set up the Constellation Network
module "network" {
  depends_on = [data.xrcm_check.check_deviceid_mismatched]

  count = ids_mismatched ? 1 : 0
  source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//network"
  //source = "../network"

  network = var.network
  leaf_bandwidth = var.leaf_bandwidth
  hub_bandwidth = var.hub_bandwidth
  client-2-dscg     = var.client-2-dscg
  filtered_devices = [for k,v in local.ids_mismatched_devices : k]
}

module "network" {
  depends_on = [data.xrcm_check.check_deviceid_mismatched]

  count = ids_mismatched ? 0 : 1
  source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//network"
  //source = "../network"

  network = var.network
  leaf_bandwidth = var.leaf_bandwidth
  hub_bandwidth = var.hub_bandwidth
  client-2-dscg     = var.client-2-dsc
}

