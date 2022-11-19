variable "devices_file" {
  type    = string
  default = ""
}

variable "device_names" {
  type    = list
  default = []
}

variable "state" {
  type    = string
  default = "ONLINE"
}

variable "save" {
  type    = bool
  default = false
}
