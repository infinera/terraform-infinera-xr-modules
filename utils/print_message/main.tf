resource "null_resource" "print" {

  provisioner "local-exec" {
    command = "echo '${upper(var.title)}:\n ${var.message}'"
  }
}