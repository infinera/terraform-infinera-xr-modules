
variable filteredhubnames {
  type = list(string)
  default = []
}

variable filteredleafnames {
  type = list(string)
  default = []
}
// Map of module names to map of module config, clients and lines
variable network {
  type = object({
      configs = object({
                        portspeed = optional(string)
                        trafficmode = optional(string)
                        modulation = optional(string)
                      })
      setup = map(object({ 
                moduleconfig  = object( {fiberconnectionmode = optional(string)
                                        tcmode = optional(bool)
                                        configuredrole = optional(string)}),
                moduleclients = list(string),
                modulecarriers= list(object({lineptpid = string, carrierid = string}))
                }))})
  description = "for each module, specify its config, it client port and line port "
  default = {
      configs = { portspeed = ""
                  trafficmode = "L2Mode"
                  modulation = "" 
                }
      setup = {
        xr-regA_H1-Hub = {
          moduleconfig = { configuredrole = "hub"}
          moduleclients = ["1","2" ]
          modulecarriers = [{ lineptpid = "1", carrierid = "1"}]
        }
        xr-regA_H1-L1 = {
          moduleconfig = { configuredrole = "leaf"}
          moduleclients = ["1"]
          modulecarriers = [{ lineptpid = "1", carrierid = "1"} ]
        }
        xr-regA_H1-L2 = {
          moduleconfig = { configuredrole = "leaf"}
          moduleclients = ["1"]
          modulecarriers = [{ lineptpid = "1", carrierid = "1"} ]
        }
        xr-regA_H1-L3 = {
          moduleconfig = { configuredrole = "leaf"}
          moduleclients = ["1"]
          modulecarriers = [{ lineptpid = "1", carrierid = "1"} ]
        }
        xr-regA_H1-L4 = {
          moduleconfig = { configuredrole = "leaf"}
          moduleclients = ["1"]
          modulecarriers = [{ lineptpid = "1", carrierid = "1"} ]
        }
        xr-regA_H2-L1 = {
          moduleconfig = { configuredrole = "leaf"}
          moduleclients = ["1"]
          modulecarriers = [{ lineptpid = "1", carrierid = "1"} ]
        }
        xr-regA_H2-L2 = {
          moduleconfig = { configuredrole = "leaf"}
          moduleclients = ["1"]
          modulecarriers = [{ lineptpid = "1", carrierid = "1"} ]
        }
        xr-regA_H2-L3 = {
          moduleconfig = { configuredrole = "leaf"}
          moduleclients = ["1"]
          modulecarriers = [{ lineptpid = "1", carrierid = "1"} ]
        }
        xr-regA_H2-L4 = {
          moduleconfig = { configuredrole = "leaf"}
          moduleclients = ["1"]
          modulecarriers = [{ lineptpid = "1", carrierid = "1"} ]
        }
      }
    }
}

variable network-carriers {
  type = map(object({
      modulation = optional(string)
      clientportmode = optional(string)
      constellationfrequency = optional(number)
    }))
    description = "Defines the modules' carrier intents"
    // only add the intent that want to change. Otherwise the dedault variable shall be used.
    default = {
    }
}