terraform {
  required_providers {
    xrcm = {
      source  = "infinera.com/poc/xrcm"
    }
  }
  // required_version = "~> 1.1.3"
}

resource "xrcm_cfg" "hub"  {
  configuredrole = var.hub_configuredrole
  trafficmode = var.trafficmode
  fiberconnectionmode = var.fiberconnectionmode
 //  tcmode = true
  n =  var.hub_n
}

