
variable "hub_names" {
  type    = list(string)
  description = "Add hub name, only one entry supported"
}

variable "hub-leaf-carrier-diag" {
 type = map(map(object({
    loopback     = string
    at   = string
  })))
  description = "Defines the loopback test between Hub and its leaves"
}