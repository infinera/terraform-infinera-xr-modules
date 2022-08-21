
variable "ethernet-prbs-diag" {
  type = map(map(object({
    facprbsgen     = string
    facprbsmon   = string
  })))
  description = "Defines the loopback test for Module EThernet Ports"
}