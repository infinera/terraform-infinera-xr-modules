
variable "aclist" {
  type = map(object({
    clientindex = number
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

variable "module_clients" {
  type    = map(list(object({clientid = string, portspeed = optional(string)})))
}