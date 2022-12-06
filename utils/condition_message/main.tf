
locals {
  message = "${upper(var.title)}:\n ${var.message}"
}

output "show_message" {
  value = var ? local.message : ""
}