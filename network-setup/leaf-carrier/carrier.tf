terraform {
  required_providers {
    xrcm = {
      source = "infinera.com/poc/xrcm"
    }
  }
  // required_version = "~> 1.1.3"
}

resource "xrcm_carrier" "leaf" {
  // aid = var.aid // ??   
  // name required to map to device id, used by resource provider
  n                      = var.leafname
  portid                 = var.portid
  carrierid              = var.carrierid
  // fiberconnectionmode    = var.fiberconnectionmode
  modulation             = var.modulation
  clientportmode         = var.clientportmode
  // maxdigitalsubcarriers  = var.maxdigitalsubcarriers
  constellationfrequency = var.constellationfrequency
}
