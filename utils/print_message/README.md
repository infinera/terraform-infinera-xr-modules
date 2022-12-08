# Utiles: Message 
This module will output to the run a message which have *title* and *content*

```
  module "print_message" {
    source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//utils/print_message"
    //source = "../print_message"
    title = title
    content = var
  }

  resource "null_resource" "print" {

  provisioner "local-exec" {
    command = "echo '${upper(var.title)}:\n ${var.message}'"
  }
}

output {
  value = mess
}
```