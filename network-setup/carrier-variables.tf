// If frequencyCtrl = Host, Host is the config owner
// if frequencyCtrl = XR, CM is the config owner
variable "constellationfrequency" {
  type    = number
  default = 455500
}

// module URI       :(/ports/{lineptpid}/carriers/{carrierid})
// fixed for 1 lineptp and 1 carrier system to 1
variable "lineptpid" {
  type    = string
  default = "1"
}
