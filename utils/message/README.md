# Message 

## Description
After the *terraform apply*, display a message which have *title* and *content*

## Inputs
1. Tiltle: Title of the message
```
variable "title" {
  type    = string
  default = "Title"
}
```
2. Content: Content of the message
```
variable "content" {
  type    = string
  default = "Content"
}
```
## Outputs
1. message:
```
   message = stringg // "${upper(var.title)}:\n ${var.content}"
```
## Usage:
```
module "message" {
  source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//utils/message"

  title = "title"
  content = "content"
}

output {
  value = module.message.message
}
```