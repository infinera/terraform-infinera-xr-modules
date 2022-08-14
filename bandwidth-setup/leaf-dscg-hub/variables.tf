// module resource  : xr.dscg
// module URI       :(/ports/{lineptpid}/carriers/{carrierid}/dscgs)
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

variable "leafbandwidth" {
  type = map(object({
    hubdscgid     = string
    leafdscgid    = string
    hubdscidlist  = list(string)
    leafdscidlist = list(string)
    direction     = string
  }))
}

variable "hubbandwidth" {
  type = map(object({
    hubdscgid     = string
    leafdscgid    = string
    hubdscidlist  = list(string)
    leafdscidlist = list(string)
    direction     = string
  }))
}

/*
variable "leafbandwidth" {
  type = map(object({
    hubdscgid    = string
    leafdscgid   = string
    hubdscidlistds = list(string)
    leafdscidlistds = list(string)
    hubdscidlistus = list(string)
    leafdscidlistus = list(string)
  }))
}
*/

