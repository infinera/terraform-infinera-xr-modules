
variable "aclist" {
  type = map(object({
    clientindex = number
    dscgaid     = string

    capacity      = number
    imc           = string
    imc_outer_vid = string
    emc           = string
    emc_outer_vid = string
  }))
  description = "clientaid to DSCG ID"
}

variable "n" {
  type = string
}

variable "trafficmode" {
  type = string
}

variable "online" {
  type = bool
}

variable "module_clients" {
  type = map(list(object({ clientaid = string, portspeed = optional(string) })))
}
