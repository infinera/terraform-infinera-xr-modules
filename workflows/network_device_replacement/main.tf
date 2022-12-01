
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
module  "network_with_IDs_check" {
  source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//tasks/network_with_IDs_check"
  //source = "../../workflows/network_with_IDs_check"

  assert = var.assert
  devices_file = var.devices_file
}

output "message" {
  value = length(module.network_with_IDs_check.device_names) > 0 ? "Devices with ID(s) Mismatched:\n${join("\n", module.network_with_IDs_check.device_names)}\n\nThe mismatched devices shall be filtered out from the hub and leaf devices. \nThis shall clean up the state and remove all dangling resources in these ID mismatched devices" : " There is no ID mismatched devices. All devices are configured."
}

// Set up the Constellation Network
module "network" {
  depends_on = [module.network_with_IDs_check]

  source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//tasks/network"
  //source = "../network"

  network = var.network
  leaf_bandwidth = var.leaf_bandwidth
  hub_bandwidth = var.hub_bandwidth
  client-2-dscg     = var.client-2-dscg
  filtered_devices = module.network_with_IDs_check.device_names
}


