// module resource  : xr.carrier
// module URI       :(/ports/

// module URI       :(/ports/{portid}/carriers/{carrierid})
// fixed for 1 port and 1 carrier system to 1

variable "n" {
  type    = string
  default = "1"
}

variable "portid" {
  type    = string
  default = "1"
}

variable "carrierid" {
  type    = string
  default = "1"
}

variable "dscids" {
  type = list(string)
}

/*variable "usability" {
  type    = string
  default = "usable"
}*/

variable "txenabled" {
  type    = bool
  default = false
}

variable "rxenabled" {
  type    = bool
  default = false
}

/* variable "facprbsmonenabled" {
  type    = bool
  default = false
}

variable "facprbsgenenabled" {
  type    = bool
  default = false
}

variable "n" {
  type    = string
  default = "XR-SFO-Hub"
}*/

# variable "poweroffset" {
#   type    = number
#   default = 0
# }
