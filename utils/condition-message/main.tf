terraform {
  required_providers {
    xrcm = {
      source = "infinera.com/poc/xrcm"
    }
  }
}
locals {
  test = var.test
  message = "${upper(var.title)}:\n ${var.message}"
}

output "show_message" {
  value = local.test ? local.message : ""
}