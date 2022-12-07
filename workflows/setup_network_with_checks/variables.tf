// If this flag is set, the module shall stop executing if there is a mismatched in device vession
// Otherwise continue to run.
variable asserts {
  type = list(string)
  default = ["HostAttributeNMismatched"]
   #  Support Values = HostAttribute, HostAttributeNMismatched, HostAttributeNMatched, NonHostAttribute, NonHostAttributeNMismatched, NonHostAttributeNMatched,  Matched, Mismatched
}

