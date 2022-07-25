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

variable "facprbsgenenabled" {
  type    = bool
  default = false
}

variable "facprbsmonenabled" {
  type    = bool
  default = false
}
