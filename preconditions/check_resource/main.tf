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

// get and filter all the resources that meet the condition
module "get_and_filter_checked_resources"  {
  //source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//utils/get_and_filter_checked_resources"
  source = "../../utils/get_and_filter_checked_resources"

  resource_type = var.resource_type
  filter = var.condition
  network = var.network
}

// check and throw message if the condition is met
data "xrcm_check" "check_resource" {
    depends_on = [
      module.get_and_filter_checked_resources
    ]
    condition = length(module.get_and_filter_checked_resources.device_names) > 0
    description = "Check : ${var.condition} for resource ${var.resource_type}: Found in ${join(",", module.get_and_filter_checked_resources.device_names)}"
    throw = "The <<${var.resource_type}>> resource(s) meets the condition <<${var.condition}>>: [${var.message}].\n ${jsonencode(module.get_and_filter_checked_resources.resources)}"
}

