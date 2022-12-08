# Utiles: Message 
This module will output to the run a message which have *title* and *content*

# Usage
```
module "message" {
  source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//utils/message"
  //source = "../print_message"
  title = "title"
  content = "content"
}

output {
  value = module.message.message
}
```