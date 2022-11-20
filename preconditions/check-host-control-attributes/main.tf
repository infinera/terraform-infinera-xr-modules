terraform {
  required_providers {
    xrcm = {
      source = "infinera.com/poc/xrcm"
    }
  }
}

locals {
  module_carriers = { for k,v in var.network.setup: k => v.modulecarriers[0]}
  module_clients =  { for k,v in var.network.setup: k => v.moduleclients }
}

data "xrcm_detaildevices" "onlinedevices" {
  names = [for k,v in var.network.setup: k ]
  state = "ONLINE"
}

data "xrcm_carriers" "onlinedevices" {
  names = [for k,v in var.network.setup: k ]
  state = "ONLINE"
}

locals {

}


// check if module config attributes are controlled by host or not
data "xrcm_check" "check_module_config_control" {
  condition = true
  description = "Check if Host is modules'configs controller: ${join(",", local.device_names)}"
  throw = "Module config is controlled by Host:\n${join("\n", ["local.deviceid_checks_outputs)"]}\nCan't configure unless IPM is the controller"
}

// check if module ethernet attributes are control by host or not
data "xrcm_check" "check_module_ethernet_control" {
  condition = true
  description = "Check if Host is modules'Ethernets controller: ${join(",", local.device_names)}"
  throw = "Ethernets' attributes are controlled by Host:\n${join("\n", local.deviceid_checks_outputs)}\nCan't configure unless IPM is the controller"
}

// check if module ethernet attributes are control by host or not
data "xrcm_check" "check_module_carriers_control" {
  condition = true
  description = "Check if Host is modules'carriers controller: ${join(",", local.device_names)}"
  throw = "Ethernets' attributes are controlled by Host:\n${join("\n", local.deviceid_checks_outputs)}\nCan't configure unless IPM is the controller"
}


