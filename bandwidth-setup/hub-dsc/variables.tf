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


variable "dscidlist" {
  type = list(string)
}

variable "tx_bandwithlist" {
  type = list(string)
}


variable "rx_bandwithlist" {
  type = list(string)
}

/*
variable "all_leafs" {
  type = list(map(object({
    hubdscgid     = string
    leafdscgid    = string
    hubdscidlist  = list(string)
    leafdscidlist = list(string) 
    direction     = string // possible values: bidi, us, ds
  })))
}
*/




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
