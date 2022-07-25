// module resource  : xr.dscg
// module URI       :(/ports/{portid}/carriers/{carrierid}/dscgs)
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

variable "leafbandwidth" {
  type = map(object({
    hubdscgid    = string
    leafdscgid   = string
    hubdscidlist = list(string)
    leafdscidlist = list(string)
  }))
}
