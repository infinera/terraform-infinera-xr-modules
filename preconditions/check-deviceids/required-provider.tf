terraform {
  required_providers {
    xrcm = {
      source = "infinera.com/poc/xrcm"
    }
  }
}


provider "xrcm" {
  username = "dev" //var.user
  password = "xrSysArch3" //var.password
  host     = "https://sv-kube-prd.infinera.com:443" //var.host
}