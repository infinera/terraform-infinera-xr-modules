variable "hubdsccount" {
  type    = number
  default = 16
}

variable "leafdsccount" {
  type    = number
  default = 4
}

variable "hubdscids" {
  type        = list(string)
  description = "Hub DSC IDs"
  default     = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16"]
}

variable "leafdscids" {
  type        = list(string)
  description = "Leaf DSC IDs"
  default     = ["1", "2", "3", "4"]
}
