variable "module_carriers" {
  type    = map(object({lineptpid = string, carrierid = string, modulation = optional(string), clientportmode = optional(string), constellationfrequency = optional(number)}))
}

