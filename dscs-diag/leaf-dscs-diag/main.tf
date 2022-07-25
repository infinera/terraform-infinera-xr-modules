terraform {
  required_providers {
    xrcm = {
      source = "infinera.com/poc/xrcm"
    }
  }
  // required_version = "~> 1.1.3"
}
  
resource "xrcm_dsc_diag" "leaf_dsc_diag" {

 for_each = toset(var.dscids)
    n = var.n
    portid = var.portid
    carrierid = var.carrierid
    dscid = each.value
    facprbsgenenabled = var.facprbsgenenabled
    facprbsmonenabled = var.facprbsmonenabled
}
