
variable "ethernet-loopback-diag" {
  type = map(map(object({
    loopbacktype     = string
    loopbackmode   = string
  })))
  description = "Defines the loopback test for Module EThernet Ports"
}