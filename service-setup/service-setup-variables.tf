variable "client-2-dscg" {
  type = map(map(object({
    clientid = string
    dscgid   = string
    lctype = string
    capacity = number
    imc = string
    imc_outer_vid = string
    emc = string
    emc_outer_vid = string      
  })))
  description = "Defines the local connections for each node in the network. each conection include the cliend id and dscg id"
}

variable "acpres" {
  type    = string
  default = "true" // true or false
}