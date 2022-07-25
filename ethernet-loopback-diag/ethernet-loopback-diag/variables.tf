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

variable "ethernet-loopback-diag" {
 type = map(map(object({
    loopbackmode     = string
    loopbacktype   = string
  })))
  description = "Defines the PRBS test for Module EThernet Ports"
}

variable "loopbackmode" {
  type    = string
  default = ""
}

variable "loopbacktype" {
  type    = string
  default = ""
}
