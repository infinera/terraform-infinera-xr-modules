```
  module "print_message" {
    //source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//utils/print_message"
    source = "../print_message"
    title = "test"
    message = jsonencode(local.queries)
  }
```