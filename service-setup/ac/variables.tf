// module resource  : xr.ac
// module URI       :(/ethernets/{}/acs/)
/*
variable "clientid" {
  type    = string
}

variable "acid" {
  type    = string
}

variable "rate" {
  type    = number //Rate in gbps, multiples of 25G
}

//ingress match criteria: {MatchAll, MatchOuterVID}
variable "imc" {
  type = string
}

//ingress match outer vlan ID 
//string format -IDs separated by "&" and/or ranges of VLAN IDs connected with "&&". 
//For example "10 & 20 & 50 && 100" to represent the 52 VLAN IDs 10, 20 and 50-100.
variable "imcoutervid" {
  type = string
}

//egress match criteria: {MatchAll, MatchOuterVID}
variable "emc" {
  type = string
}

//egress match outer vlan ID 
//string format -IDs separated by "&" and/or ranges of VLAN IDs connected with "&&". 
//For example "10 & 20 & 50 && 100" to represent the 52 VLAN IDs 10, 20 and 50-100.
variable "emc_outer_vid" {
  type = string
}
*/

variable "aclist" {
  type = map(object({
    clientid = string
    dscgid   = string
    lctype = string
    capacity = number
    imc = string
    imc_outer_vid = string
    emc = string
    emc_outer_vid = string
  }))
  description = "ClientID to DSCG ID"
}

variable "n" {
  type = string
}

variable "trafficmode" {
  type    = string
}

variable "online" {
  type    = bool
}
