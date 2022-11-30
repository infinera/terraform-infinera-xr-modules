variable filter {
  type = string
  default = "Mismatched"
  // HostAttribute
  // HostAttributeNMismatched
  // HostAttributeNMatched
  // NonHostAttribute
  // NonHostAttributeNMismatched
  // NonHostAttributeNMatched
  // Matched
  // Mismatched
}

variable devices_resources {
  type =  list(object({ n= string, resourcetype = string, deviceid = optional(string)
                        resources = list(object({resourceid = string, attributevalues = string, controlattribute = optional(string), parentid= optional(string), grandparentid = optional(string), attributevalues = optional(list(object({attribute=string, intentvalue= string, devicevalue=optional(string), controlattribute= optional(string),isvaluematch=optional(bool), attributecontrolbyhost = optional(bool)})))})) }))
  default = []
}
