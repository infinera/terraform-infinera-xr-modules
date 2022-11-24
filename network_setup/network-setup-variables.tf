// network variables
variable "modulation" {
  type        = string
  default     = "16QAM"
  description = "network modulation to be used for all the devices"
}

variable "clientportmode" {
  type        = string
  default     = "ethernet"
  description = "client traffic used for all the ports on the hub and leafs"
}

// Required for both Hub and Leaf but different values
variable "maxdigitalsubcarriers" {
  type        = number
  default     = 16
  description = "maximum number of digital sub carriers"
}

variable "trafficmode" {
  type = string
}


// If frequencyCtrl = Host, Host is the config owner
// if frequencyCtrl = XR, CM is the config owner
# variable "constellationfrequency" {
#   type    = number
#   default = 0
# }

# // module URI       :(/ports/{lineptpid}/carriers/{carrierid})
# // fixed for 1 lineptp and 1 carrier system to 1
# variable "lineptpid" {
#   type    = string
#   default = "1"
# }

/* Not required, use the leaf names and fixed lineptp 1, carrier 1

variable "leaf_carrier_aids" {
  type = list(string)
  default = [
    "M1/P1-C1",
    "M1/P2-C1",
    "M2/P1-C1"
  ]
}

*/
