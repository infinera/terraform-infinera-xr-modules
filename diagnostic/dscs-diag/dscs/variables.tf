
variable "n" {
  type    = string
  default = "1"
}

variable "lineptpid" {
  type    = string
  default = "1"
}

variable "carrierid" {
  type    = string
  default = "1"
}

variable "dscstest" {
  type = object({
    name = string
    dscids = list(string)
    facprbsgen = string
    facprbsmon = string
  })
}
