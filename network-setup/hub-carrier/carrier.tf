terraform {
  required_providers {
    xrcm = {
      source = "infinera.com/poc/xrcm"
    }
  }
  // required_version = "~> 1.1.3"
}

resource "xrcm_carrier" "hub" {
  // fiberconnectionmode    = var.fiberconnectionmode
  modulation     = var.modulation
  clientportmode = var.clientportmode
  // maxdigitalsubcarriers  = var.maxdigitalsubcarriers
  constellationfrequency = var.constellationfrequency
  // name required to map to device id, used by resource provider
  n = var.hub_n

  lineptpid = 1
  carrierid = 1
}
