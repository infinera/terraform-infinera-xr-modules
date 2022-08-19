terraform {
  required_providers {
    xrcm = {
      source = "infinera.com/poc/xrcm"
    }
  }
  // required_version = "~> 1.1.3"
}

resource "xrcm_dsc_diag" "dsc_diag" {

  for_each          = toset(var.dscstest["dscids"])
  n                 = var.n
  lineptpid         = var.lineptpid
  carrierid         = var.carrierid
  dscid             = each.value
  facprbsgenenabled = var.dscstest["facprbsgen"]
  facprbsmonenabled = var.dscstest["facprbsmon"]
}
