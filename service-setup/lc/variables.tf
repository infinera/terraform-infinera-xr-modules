// module resource  : xr.lcs
// module URI       :(/lcs)




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
    clientid      = string
    dscgid        = string
    lctype        = string
    rate          = number
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
