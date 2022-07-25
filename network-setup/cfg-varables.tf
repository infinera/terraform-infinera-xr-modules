
// Hub Variables
variable "hub_configuredrole" {
  type    = string
  default = "hub"
}

variable "leaf_configuredrole" {
  type    = string
  default = "leaf"
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