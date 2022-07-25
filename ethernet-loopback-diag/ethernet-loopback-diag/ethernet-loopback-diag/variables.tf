
variable "ethernet-loopback-diag" {
  type = map(map(object({
    loopbackmode     = string
    loopbacktype     = string
  })))
  description = "Defines the loopback test for Module EThernet Ports"
}