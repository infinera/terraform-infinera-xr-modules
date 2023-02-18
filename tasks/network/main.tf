terraform {
  required_providers {
    xrcm = {
      source = "infinera.com/poc/xrcm"
    }
  }
}

data "xrcm_detaildevices" "onlinehubdevices" {
  names = [for k,v in var.network.setup: k if v.deviceconfig["configuredrole"] == "hub"]
  state = "ONLINE"
}

data "xrcm_detaildevices" "onlineleafdevices" {
  names = [for k,v in var.network.setup: k if v.deviceconfig["configuredrole"] == "leaf"]
  state = "ONLINE"
}


locals {
  hub_names = length(var.filtered_devices) > 0 ? setsubtract(data.xrcm_detaildevices.onlinehubdevices.devices == null ? [] : [for onlinedevice in data.xrcm_detaildevices.onlinehubdevices.devices : onlinedevice.n], var.filtered_devices) : data.xrcm_detaildevices.onlinehubdevices.devices == null ? [] : [for onlinedevice in data.xrcm_detaildevices.onlinehubdevices.devices : onlinedevice.n]
  leaf_names = length(var.filtered_devices) > 0 ? setsubtract(data.xrcm_detaildevices.onlineleafdevices.devices == null ? [] : [for onlinedevice in data.xrcm_detaildevices.onlineleafdevices.devices : onlinedevice.n], var.filtered_devices) : data.xrcm_detaildevices.onlineleafdevices.devices == null ? [] : [for onlinedevice in data.xrcm_detaildevices.onlineleafdevices.devices : onlinedevice.n]
  module_carriers = { for k,v in var.network.setup: k => v.devicecarriers[0]}
  module_clients =  { for k,v in var.network.setup: k => v.deviceclients }
}

module "network-setup" {
  source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//network_setup"
  //source = "../../network_setup"

  hub_names = local.hub_names
  leaf_names = local.leaf_names
  trafficmode = var.network.configs.trafficmode
}

module "bandwidth-setup" {
  depends_on        = [module.network-setup]
  source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//bandwidth_setup"
  //source = "../../bandwidth_setup"
  hub_names = local.hub_names
  leaf_names = local.leaf_names
  leaf_bandwidth = var.leaf_bandwidth
  hub_bandwidth = var.hub_bandwidth
  trafficmode = var.network.configs.trafficmode
  module_carriers = local.module_carriers
}

module "service-setup" {
  depends_on        = [module.bandwidth-setup]
  source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//service_setup"
  //source = "../../service_setup"
  hub_names = local.hub_names
  leaf_names = local.leaf_names
  client-2-dscg     = var.client-2-dscg
  trafficmode = var.network.configs.trafficmode
  module_carriers = local.module_carriers
  module_clients = local.module_clients
}
