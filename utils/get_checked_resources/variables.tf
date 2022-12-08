// resource type
variable resource_type {
  type = string
  default = "Carrier"
  // Device
  // DeviceConfig
  // Ethernet
  // Carrier
  // DSC
  // DSCG
}


variable queries {
  type =  list(object({ n= string, resourcetype = string, 
                        resources = list(object({resourceid = string, attributevalues = string, controlattribute = string, parentid= optional(string), parentid= optional(string), grandparentid = optional(string)})) }))
  default = []
}


variable network {
  type = object({
      configs = object({
                        portspeed = optional(string)
                        trafficmode = optional(string)
                        modulation = optional(string)
                      })
      setup = map(object({ 
                device  = optional(object( {di = optional(string),
                                        sv = optional(string)})),
                deviceconfig  = optional(object( {fiberconnectionmode = optional(string),
                                        tcmode = optional(bool),
                                        configuredrole = optional(string),
                                        trafficmode = optional(string)})),
                deviceclients = optional(list(object({clientid = string, portspeed = optional(string)}))),
                devicecarriers= optional(list(object({lineptpid = string, carrierid = string, modulation = optional(string), clientportmode = optional(string), constellationfrequency = optional(number)})))
                }))})
  description = "for each device, specify its config, it client port and line port "
  default = {
      configs = { portspeed = ""
                  trafficmode = "L2Mode"
                  modulation = "" 
                }
      setup = {
        xr-regA_H1-Hub = {
          device = { di = "76e073d6-4570-4111-4853-3bd52878dfa5", sv = "1.00"}
          deviceconfig = { configuredrole = "hub", trafficmode ="L1Mode"}
          deviceclients = [{ clientid = "1", portspeed="100"}, { clientid = "2",portspeed="200"}]
          devicecarriers = [{ lineptpid = "1", carrierid = "1", modulation ="16QAM"}]
        }
        xr-regA_H1-L1 = {
          device = { di = "76e073d6-4570-4111-4853-3bd52878dfa5", sv = "1.00"}
          deviceconfig = { configuredrole = "leaf", trafficmode ="L1Mode"}
          deviceclients = [{ clientid = "1", portspeed="100"}]
          devicecarriers = [{ lineptpid = "1", carrierid = "1", modulation ="16QAM"} ]
        }
        /*xr-regA_H1-L2 = {
          deviceconfig = { configuredrole = "leaf", trafficmode ="L1Mode"}
          deviceclients = [{ clientid = "1", portspeed="100"}]
          devicecarriers = [{ lineptpid = "1", carrierid = "1", modulation ="16QAM"} ]
        }
        xr-regA_H1-L3 = {
          deviceconfig = { configuredrole = "leaf", trafficmode ="L1Mode"}
          deviceclients = [{ clientid = "1", portspeed="100"}]
          devicecarriers = [{ lineptpid = "1", carrierid = "1", modulation ="16QAM"} ]
        }
        xr-regA_H1-L4 = {
          deviceconfig = { configuredrole = "leaf", trafficmode ="L1Mode"}
          deviceclients = [{ clientid = "1", portspeed="100"}]
          devicecarriers = [{ lineptpid = "1", carrierid = "1", modulation ="16QAM"} ]
        }
        xr-regA_H2-L1 = {
          deviceconfig = { configuredrole = "leaf", trafficmode ="L1Mode"}
          deviceclients = [{ clientid = "1", portspeed="100"}]
          devicecarriers = [{ lineptpid = "1", carrierid = "1", modulation ="16QAM"} ]
        }
        xr-regA_H2-L2 = {
          deviceconfig = { configuredrole = "leaf", trafficmode ="L1Mode"}
          deviceclients = [{ clientid = "1", portspeed="100"}]
          devicecarriers = [{ lineptpid = "1", carrierid = "1", modulation ="16QAM"} ]
        }
        xr-regA_H2-L3 = {
          deviceconfig = { configuredrole = "leaf", trafficmode ="L1Mode"}
          deviceclients = [{ clientid = "1", portspeed="100"}]
          devicecarriers = [{ lineptpid = "1", carrierid = "1", modulation ="16QAM"} ]
        }
        xr-regA_H2-L4 = {
          deviceconfig = { configuredrole = "leaf", trafficmode ="L1Mode"}
          deviceclients = [{ clientid = "1", portspeed="100"}]
          devicecarriers = [{ lineptpid = "1", carrierid = "1", modulation ="16QAM"} ]
        }*/
      }
    }
}