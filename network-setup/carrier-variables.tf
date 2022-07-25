// If frequencyCtrl = Host, Host is the config owner
// if frequencyCtrl = XR, CM is the config owner
variable "constellationfrequency" {
  type    = number
  default = 455500
}

// module URI       :(/ports/{portid}/carriers/{carrierid})
// fixed for 1 port and 1 carrier system to 1
variable "portid" {
  type    = string
  default = "1"
}