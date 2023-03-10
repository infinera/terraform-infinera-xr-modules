

variable "acpres" {
  type    = string
  default = "true" // true or false
}

variable "lclist" {
  type = map(object({
    clientindex = number
    dscgaid     = string

    capacity      = number
    imc           = string
    imc_outer_vid = string
    emc           = string
    emc_outer_vid = string
  }))
  description = "clientaid to DSCG ID"
}

variable "n" {
  type = string
}


variable "lineptpid" {
  type    = string
  default = "1"
}


variable "carrierid" {
  type    = string
  default = "1"
}
variable "trafficmode" {
  type = string
}
