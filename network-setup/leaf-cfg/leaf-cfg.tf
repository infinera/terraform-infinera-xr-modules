terraform {
  required_providers {
    xrcm = {
      source  = "infinera.com/poc/xrcm"
    }
  }
  // required_version = "~> 1.1.3"
}

resource "xrcm_cfg" "leaf" {
  // Create one instance for each leaf
  n =  var.n
  configuredrole = var.leaf_configuredrole
  trafficmode = var.trafficmode
  fiberconnectionmode = var.fiberconnectionmode
}
