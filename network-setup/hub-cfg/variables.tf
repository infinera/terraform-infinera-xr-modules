// network variables
variable "modulation" {
  type    = string
  default = "16QAM"
}

variable "clientportmode" {
  type    = string
  default = "ethernet"
}

// 400G Hub module
variable "maxdigitalsubcarriers" {
  type    = number
  default = 16
}

variable "trafficmode" {
  type    = string
  default = "L1Mode"
}

variable "tcMode" {
  type    = string
  default = "Enabled"
}


// Common variables
variable "fiberconnectionmode" {
  type    = string
  default = "dual"
}

// Hub Variables
variable "hub_configuredrole" {
  type    = string
  default = "hub"
}

variable "hub_n" {
  type    = string
}

