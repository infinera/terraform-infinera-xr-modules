// module resource  : xr.carrier
// module URI       :(/ports/

// module URI       :(/ports/{lineptpid}/carriers/{carrierid})
// fixed for 1 lineptp and 1 carrier system to 1

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
