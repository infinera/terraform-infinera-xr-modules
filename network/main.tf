
// This module initializes the:
// network
// bandwidht
// service

data "xrcm_detaildevices" "onlinehubdevices" {
  names = [for k,v in var.network.setup: k if v.moduleconfig["configuredrole"] == "hub"]
  state = "ONLINE"
}

data "xrcm_detaildevices" "onlineleafdevices" {
  names = [for k,v in var.network.setup: k if v.moduleconfig["configuredrole"] == "leaf"]
  state = "ONLINE"
}


locals {
  hub_names = length(var.filteredhub_names) > 0 ? setsubtract(data.xrcm_detaildevices.onlinehubdevices.devices == null ? [] : [for onlinedevice in data.xrcm_detaildevices.onlinehubdevices.devices : onlinedevice.name], var.filteredhub_names) : data.xrcm_detaildevices.onlinehubdevices.devices == null ? [] : [for onlinedevice in data.xrcm_detaildevices.onlinehubdevices.devices : onlinedevice.name]
  leaf_names = length(var.filteredleaf_names) > 0 ? setsubtract(data.xrcm_detaildevices.onlineleafdevices.devices == null ? [] : [for onlinedevice in data.xrcm_detaildevices.onlineleafdevices.devices : onlinedevice.name], var.filteredleaf_names) : data.xrcm_detaildevices.onlineleafdevices.devices == null ? [] : [for onlinedevice in data.xrcm_detaildevices.onlineleafdevices.devices : onlinedevice.name]
  module_carriers = { for k,v in var.network.setup: k => v.modulecarriers[0]}
  module_clients =  { for k,v in var.network.setup: k => v.moduleclients }
}

module "network-setup" {
  source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//network-setup"
  //source = "../network-setup"

  hub_names = local.hub_names
  leaf_names = local.leaf_names
  trafficmode = var.network.configs.trafficmode
}

module "bandwidth-setup" {
  depends_on        = [module.network-setup]
  source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//bandwidth-setup"
  //source = "../bandwidth-setup"
  hub_names = local.hub_names
  leaf_names = local.leaf_names
  leaf_bandwidth = var.leaf_bandwidth
  hub_bandwidth = var.hub_bandwidth
  trafficmode = var.network.configs.trafficmode
  module_carriers = local.module_carriers
}

module "service-setup" {
  depends_on        = [module.bandwidth-setup]
  source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//service-setup"
  //source = "../service-setup"
  hub_names = local.hub_names
  leaf_names = local.leaf_names
  client-2-dscg     = var.client-2-dscg
  trafficmode = var.network.configs.trafficmode
  module_carriers = local.module_carriers
  module_clients = local.module_clients
}


/*
module "dscs-diag" {
  source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//diagnostic/dscs-diag"

  lineptpid = 1
  carrierid = 1
  dscstest = var.dscstest
}

/*module "carrier-diag" {
  source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//diagnostic/carrier-diag"

 // depends_on        = [module.bandwidth-setup]
  
  hub_names         = var.hub_names
  hub-leaf-carrier-diag = var.hub-leaf-carrier-diag
}

module "ethernet-loopback-diag" {
  source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//diagnostic/ethernet-loopback-diag"

  //depends_on        = [module.bandwidth-setup]

  ethernet-loopback-diag = var.ethernet-loopback-diag
}*/