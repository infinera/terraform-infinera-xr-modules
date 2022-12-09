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

  network = var.network
  assert = contains(var.asserts, "Version")
}
 
module "network_host_mismatch_attribute_check" {
  source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//tasks/network_host_mismatch_attribute_check"
  //source = "../../tasks/network_host_mismatch_attribute_check"

  network = var.network
  assert = contains(var.asserts, "HostAttributeNMismatched")
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

output "devices_version_check_message" {
  value = length(module.network_with_versions_check.device_names) > 0 ? "Devices with mismatched version:\n${join("\n", module.network_with_versions_check.device_version_checks_outputs)}\n\nContinue to run the workflow with the assumption that the different device software versions are compatible" : "All devices' version are matched or compatible."
}

output "host_attribute_mismatch_check_message" {
  value = length(module.network_host_mismatch_attribute_check.device_names) > 0 ? "Devices with mismatched Host attribute(s):\n${join("\n", module.network_host_mismatch_attribute_check.mismatched_host_attribute_check_outputs)}\n\nMismatched Host attributes can not be updated by IPM.\nTo continue the run for other devices which has no change on Host attributes; please add 'HostAttributeNMismatched' to asserts" : " There is no mismatched host attribute" 
}




