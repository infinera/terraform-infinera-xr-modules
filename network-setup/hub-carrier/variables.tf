// module resource  : xr.carrier
// module URI       :(/ports/{}/carriers/{})

// network variables
variable "modulation" {
  type    = string
  default = "16QAM"
}

variable "clientportmode" {
  type    = string
  default = "ethernet"
}

// Hub carrier only, Leaf - not required
variable "maxdigitalsubcarriers" {
  type    = number
  default = 16
}

// Common variables

// If frequencyCtrl = Host, Host is the config owner
// if frequencyCtrl = XR, CM is the config owner
variable "constellationfrequency" {
  type    = number
  default = 0
}
// module URI       :(/ports/{lineptpid}/carriers/{carrierid})
// fixed for 1 lineptp and 1 carrier system to 1
variable "lineptpid" {
  type    = string
  default = "1"
}


variable "carrierid" {
  type    = string
  default = "1"
}


variable "hub_n" {
  type    = string
  default = "XR-SFO-Hub"
}
