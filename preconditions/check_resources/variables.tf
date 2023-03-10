// Map of module names to map of module config, clients and lines
variable "network" {
  type = object({
    configs = object({
      portspeed   = optional(string)
      trafficmode = optional(string)
      modulation  = optional(string)
    })
    setup = map(object({
      moduleconfig = object({ fiberconnectionmode = optional(string),
        tcmode         = optional(bool),
        configuredrole = optional(string),
      trafficmode = optional(string) }),
      moduleclients  = list(object({ clientaid = string, portspeed = optional(string) })),
      modulecarriers = list(object({ lineptpid = string, carrierid = string, modulation = optional(string), clientportmode = optional(string), constellationfrequency = optional(number) }))
  })) })
  description = "for each module, specify its config, it client port and line port "
  default = {
    configs = { portspeed = ""
      trafficmode = "L2Mode"
      modulation  = ""
    }
    setup = {
      xr-regA_H1-Hub = {
        moduleconfig   = { configuredrole = "hub", trafficmode = "L1Mode" }
        moduleclients  = [{ clientaid = "1", portspeed = "100" }, { clientaid = "2", portspeed = "100" }]
        modulecarriers = [{ lineptpid = "1", carrierid = "1", modulation = "16QAM" }]
      }
      xr-regA_H1-L1 = {
        moduleconfig   = { configuredrole = "leaf", trafficmode = "L2Mode" }
        moduleclients  = [{ clientaid = "1", portspeed = "300" }]
        modulecarriers = [{ lineptpid = "1", carrierid = "1", modulation = "16QAM" }]
      }
      /*xr-regA_H1-L2 = {
          moduleconfig = { configuredrole = "leaf", trafficmode ="L1Mode"}
          moduleclients = [{ clientaid = "1", portspeed="100"}]
          modulecarriers = [{ lineptpid = "1", carrierid = "1", modulation ="16QAM"} ]
        }
        xr-regA_H1-L3 = {
          moduleconfig = { configuredrole = "leaf", trafficmode ="L1Mode"}
          moduleclients = [{ clientaid = "1", portspeed="100"}]
          modulecarriers = [{ lineptpid = "1", carrierid = "1", modulation ="16QAM"} ]
        }
        xr-regA_H1-L4 = {
          moduleconfig = { configuredrole = "leaf", trafficmode ="L1Mode"}
          moduleclients = [{ clientaid = "1", portspeed="100"}]
          modulecarriers = [{ lineptpid = "1", carrierid = "1", modulation ="16QAM"} ]
        }
        xr-regA_H2-L1 = {
          moduleconfig = { configuredrole = "leaf", trafficmode ="L1Mode"}
          moduleclients = [{ clientaid = "1", portspeed="100"}]
          modulecarriers = [{ lineptpid = "1", carrierid = "1", modulation ="16QAM"} ]
        }
        xr-regA_H2-L2 = {
          moduleconfig = { configuredrole = "leaf", trafficmode ="L1Mode"}
          moduleclients = [{ clientaid = "1", portspeed="100"}]
          modulecarriers = [{ lineptpid = "1", carrierid = "1", modulation ="16QAM"} ]
        }
        xr-regA_H2-L3 = {
          moduleconfig = { configuredrole = "leaf", trafficmode ="L1Mode"}
          moduleclients = [{ clientaid = "1", portspeed="100"}]
          modulecarriers = [{ lineptpid = "1", carrierid = "1", modulation ="16QAM"} ]
        }
        xr-regA_H2-L4 = {
          moduleconfig = { configuredrole = "leaf", trafficmode ="L1Mode"}
          moduleclients = [{ clientaid = "1", portspeed="100"}]
          modulecarriers = [{ lineptpid = "1", carrierid = "1", modulation ="16QAM"} ]
        }*/
    }
  }
}
