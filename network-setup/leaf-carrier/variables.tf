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

// 100G Leaf modules
variable "maxdigitalsubcarriers" {
  type    = number
  default = 4
}

// Common variables
variable "fiberconnectionmode" {
  type    = string
  default = "dual"
}

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

variable "aid" {
  type    = string
  default = ""
}

variable "leafname" {
  type = string
}

