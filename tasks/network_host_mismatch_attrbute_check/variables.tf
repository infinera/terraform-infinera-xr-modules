// If this flag is set, the module shall stop executing if there is devices' attribute meets the specified condition
// Otherwise continue to run.
variable assert {
  type = bool
  default = true
}

variable condition {
  type = string
  default = "HostAttribute"
  #  Support Values = HostAttribute, HostAttributeNMismatched, HostAttributeNMatched, NonHostAttribute, NonHostAttributeNMismatched, NonHostAttributeNMatched,  Matched, Mismatched
}
