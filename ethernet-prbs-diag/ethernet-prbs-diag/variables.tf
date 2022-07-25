// module resource  : xr.carrier
// module URI       :(/ports/

// module URI       :(/ports/{portid}/carriers/{carrierid})
// fixed for 1 port and 1 carrier system to 1

variable "n" {
  type    = string
  default = "1"
}

variable "ethernetids" {
  type = list(string)
}

variable "ethernet-prbs-diag" {
 type = map(map(object({
    facprbsgen     = string
    facprbsmon   = string
  })))
  description = "Defines the PRBS test for Module EThernet Ports"
}

variable "facprbsgenenabled" {
  type    = bool
  default = false
}

variable "facprbsmonenabled" {
  type    = bool
  default = false
}
