
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


