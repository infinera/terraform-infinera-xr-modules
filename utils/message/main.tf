terraform {
  required_providers {
    xrcm = {
      source = "infinera.com/poc/xrcm"
    }
  }
}

locals {
  message = "${upper(var.title)}:\n ${var.content}"
}

output "message" {
  value = var ? local.message : ""
}