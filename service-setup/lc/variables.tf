// module resource  : xr.lcs
// module URI       :(/lcs)




variable "lctype" {
  type    = string
  default = "biDir"
}


variable "lclist" {
  type = map(object({
    clientid = string
    dscgid   = string
  }))
  description = "ClientID to DSCG ID"
}


variable "n" {
  type = string
}


variable "portid" {
  type    = string
  default = "1"
}


variable "carrierid" {
  type    = string
  default = "1"
}
