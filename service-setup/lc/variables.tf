
variable "lctype" {
  type    = string
  default = "biDir" //uniDirUs, uniDirDs
}

variable "acpres" {
  type    = string
  default = "true" // true or false
}

variable "lclist" {
  type = map(object({
    clientindex = number
    dscgid        = string
    lctype        = string
    capacity          = number
    imc           = string
    imc_outer_vid = string
    emc           = string
    emc_outer_vid = string
  }))
  description = "ClientID to DSCG ID"
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
