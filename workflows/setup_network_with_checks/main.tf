terraform {
  required_providers {
    xrcm = {
      source = "infinera.com/poc/xrcm"
    }
  }
}

module "network_with_versions_check" {
  source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//tasks/network_with_versions_check"
  //source = "../../tasks/network_with_versions_check"

  assert = contains(var.asserts, "Version")
}

output "devices_version_check_message" {
  value = length(module.network_with_versions_check.device_names) > 0 ? "Devices with mismatched version:\n${join("\n", module.network_with_versions_check.device_names)}\n\nContinue to run the workflow with the assumption that the different device software versions are compatible" : "All devices' version are matched or compatible."
}

module "network_host_mismatch_attribute_check" {
  source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//tasks/network_host_mismatch_attribute_check"
  //source = "../../tasks/network_host_mismatch_attribute_check"

  assert = contains(var.asserts, "HostAttributeMismatched")
  condition = "HostAttributeMismatched"
}

output "host_attribute_mismatch_check_message" {
  value = length(module.network_host_mismatch_attribute_check.device_names) > 0 ? "Devices with mismatched Host attribute(s):\n${join("\n", module.network_host_mismatch_attribute_check.device_names)}\n\nMismatched Host attributes can not be updated by IPM.\nTo continue the run for other devices which has no change on Host attributes; please add 'HostAttributeMismatched' to asserts" : " There is no mismatched host attribute"
}

// Set up the Constellation Network
module "network" {

  source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//tasks/network"
  //source = "../network"

  network = var.network
  leaf_bandwidth = var.leaf_bandwidth
  hub_bandwidth = var.hub_bandwidth
  client-2-dscg     = var.client-2-dscg
}


