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

variable "trafficmode" {
  type    = string
  default = "L1Mode"
}

variable "tcMode" {
  type    = bool
  default = true
}

// Common variables
variable "fiberconnectionmode" {
  type    = string
  default = "dual"
}

variable "leaf_configuredrole" {
  type    = string
  default = "leaf"
}
variable "n" {
  type = string
}


