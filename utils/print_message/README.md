# Console Message 

## Description
During the *terraform apply*, display message which have *title* and *content* to the console.

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
## Outputs on the console
1. message:
```
   message = stringg // "${upper(var.title)}:\n ${var.content}"
```
## Usage:
```
module "console_message" {
  source = "git::https://github.com/infinera/terraform-infinera-xr-modules.git//utils/console_message"

  title = "title"
  content = "content"
}
```