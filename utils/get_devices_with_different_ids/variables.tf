variable "device_names" {
  type    = list
  default = ["xr-regA_H1-L1", "xr-regA_H1-Hub"]
}

variable "state" {
  type    = string
  default = "ONLINE"
}
