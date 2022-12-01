// If this flag is set, the module shall stop executing if there is devices' attribute meets the specified condition
// Otherwise continue to run.
variable assert {
  type = bool
  default = true
}

variable resource_type {
  type = string
  default = "Ethernet"
}

variable condition {
  type = string
  default = "Mismatched"
}
