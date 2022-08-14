terraform {
  required_providers {
    xrcm = {
      source = "infinera.com/poc/xrcm"
    }
  }
  // required_version = "~> 1.1.3"
}

resource "xrcm_carrier" "leaf" {
  n                      = var.leafname
  lineptpid              = var.lineptpid
  carrierid              = var.carrierid
  modulation             = var.modulation
  clientportmode         = var.clientportmode
  constellationfrequency = var.constellationfrequency
}
