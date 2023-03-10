/*
// client-2-dscg defines the local connections:
// Common attributes: Initialize clientindex, dscgaid and lctype
// L2Mode: rest of the attributes used to create AC 
// Hub device = 
//  local connection id = 
//      client id
//      dscgaid 
//Use case - XR VLAN P2P - VLAN Tagged, L2CP Carried, shared downlink capacity
*/
variable "client-2-dscg" {
  type = map(map(object({
    clientindex   = optional(number) // index to module_clients list
    dscgaid       = optional(string)
    capacity      = optional(number)
    imc           = optional(string)
    imc_outer_vid = optional(string)
    emc           = optional(string)
    emc_outer_vid = optional(string)
  })))
  description = "Defines the local connections for each node in the network. each conection include the cliend id and dscg id"

  default = {
    xr-regA_H1-Hub = {
      lc-XR-SFO_12-1234-1-ds = { // hub tx -> leaf 1/2/3/4 - 100G Shared downstream
        clientindex = 0
        dscgaid     = "1"
        capacity      = 4
        imc           = "MatchAll"
        imc_outer_vid = ""
        emc           = "None"
        emc_outer_vid = ""
      },
      lc-xr-regA_H1-L1-1-us = { // hub rcv <- leaf 1, 25G US
        clientindex = 0
        dscgaid     = "3" // US DSCG ID      
        capacity      = 1
        imc           = "None"
        imc_outer_vid = ""
        emc           = "MatchOuterVID"
        emc_outer_vid = "100"
      },
      lc-xr-regA_H1-L2-1-us = { // hub rcv -> leaf 2, 25G US
        clientindex = 0
        dscgaid     = "4" //DS DSCG ID                 
        capacity      = 1
        imc           = "None"
        imc_outer_vid = ""
        emc           = "MatchOuterVID"
        emc_outer_vid = "200"
      },
      lc-xr-regA_H1-L3-1-us = { // hub rcv -> leaf 3, 25G US
        clientindex = 0
        dscgaid     = "6" //DS DSCG ID               
        capacity      = 1
        imc           = "None"
        imc_outer_vid = ""
        emc           = "MatchOuterVID"
        emc_outer_vid = "300"
      },
      lc-xr-regA_H1-L4-1-us = { // hub rcv -> leaf 4, 25G US
        clientindex = 0
        dscgaid     = "8" //DS DSCG ID               
        capacity      = 1
        imc           = "None"
        imc_outer_vid = ""
        emc           = "MatchOuterVID"
        emc_outer_vid = "400"
      },
      lc-XR-SFO_12-5678-1-ds = { // hub tx -> leaf 5/6/7/8 - 100G Shared downstream
        clientindex = 1
        dscgaid     = "2"
        capacity      = 4
        imc           = "MatchAll"
        imc_outer_vid = ""
        emc           = "None"
        emc_outer_vid = ""
      },
      lc-xr-regA_H2-L1-1-us = { // hub rcv <- leaf 5, 25G US
        clientindex = 1
        dscgaid     = "10" // US DSCG ID       
        capacity      = 1
        imc           = "None"
        imc_outer_vid = ""
        emc           = "MatchOuterVID"
        emc_outer_vid = "500"
      },
      lc-xr-regA_H2-L2-1-us = { // hub rcv -> leaf 6, 25G US
        clientindex = 1
        dscgaid     = "12" //DS DSCG ID             
        capacity      = 1
        imc           = "None"
        imc_outer_vid = ""
        emc           = "MatchOuterVID"
        emc_outer_vid = "600"
      },
      lc-xr-regA_H2-L3-1-us = { // hub rcv -> leaf 7, 25G US
        clientindex = 1
        dscgaid     = "14" //DS DSCG ID              
        capacity      = 1
        imc           = "None"
        imc_outer_vid = ""
        emc           = "MatchOuterVID"
        emc_outer_vid = "700"
      },
      lc-xr-regA_H2-L4-1-us = { // hub rcv -> leaf 8, 25G US   
        clientindex = 1
        dscgaid     = "16" //DS DSCG ID                
        capacity      = 1
        imc           = "None"
        imc_outer_vid = ""
        emc           = "MatchOuterVID"
        emc_outer_vid = "800"
      },
    }, // end Hub AC/LCs
    xr-regA_H1-L1 = {
      lc-xr-regA_H1-Hub-ds-1 = { // leaf 1 rcv <- hub, 100G shared DS 
        clientindex = 0
        dscgaid     = "1"
        capacity      = 4
        imc           = "None"
        imc_outer_vid = ""
        emc           = "MatchOuterVID"
        emc_outer_vid = "100"
      },
      lc-xr-regA_H1-Hub-us-1 = { // leaf 1 tx -> hub, 25G shared DS 
        clientindex = 0
        dscgaid     = "2"
        capacity      = 1
        imc           = "MatchOuterVID"
        imc_outer_vid = "100"
        emc           = "None"
        emc_outer_vid = ""
      }
    },
    xr-regA_H1-L2 = {
      lc-xr-regA_H1-Hub-ds-1 = { // leaf 2 rcv <- hub, 100G shared DS 
        clientindex = 0
        dscgaid     = "1"
        capacity      = 4
        imc           = "None"
        imc_outer_vid = ""
        emc           = "MatchOuterVID"
        emc_outer_vid = "200"
      },
      lc-xr-regA_H1-Hub-us-1 = { // leaf 2 tx -> hub, 25G shared DS 
        clientindex = 0
        dscgaid     = "2"
        capacity      = 1
        imc           = "MatchOuterVID"
        imc_outer_vid = "200"
        emc           = "None"
        emc_outer_vid = ""
      }
    },
    xr-regA_H1-L3 = {
      lc-xr-regA_H1-Hub-ds-1 = { // leaf 3 rcv <- hub, 100G shared DS 
        clientindex = 0
        dscgaid     = "1"
        capacity      = 4
        imc           = "None"
        imc_outer_vid = ""
        emc           = "MatchOuterVID"
        emc_outer_vid = "300"
      },
      lc-xr-regA_H1-Hub-us-1 = { // leaf 3 tx -> hub, 25G shared DS 
        clientindex = 0
        dscgaid     = "2"
        capacity      = 1
        imc           = "MatchOuterVID"
        imc_outer_vid = "300"
        emc           = "None"
        emc_outer_vid = ""
      }
    },
    xr-regA_H1-L4 = {
      lc-xr-regA_H1-Hub-ds-1 = { // leaf 4 rcv <- hub, 100G shared DS 
        clientindex = 0
        dscgaid     = "1"
        capacity      = 4
        imc           = "None"
        imc_outer_vid = ""
        emc           = "MatchOuterVID"
        emc_outer_vid = "400"
      },
      lc-xr-regA_H1-Hub-us-1 = { // leaf 4 tx -> hub, 25G shared DS 
        clientindex = 0
        dscgaid     = "2"
        capacity      = 1
        imc           = "MatchOuterVID"
        imc_outer_vid = "400"
        emc           = "None"
        emc_outer_vid = ""
      }
    },
    xr-regA_H2-L1 = {
      lc-xr-regA_H1-Hub-ds-1 = { // leaf 5 rcv <- hub, 100G shared DS 
        clientindex = 0
        dscgaid     = "1"
        capacity      = 4
        imc           = "None"
        imc_outer_vid = ""
        emc           = "MatchOuterVID"
        emc_outer_vid = "500"
      },
      lc-xr-regA_H1-Hub-us-1 = { // leaf 5 tx -> hub, 25G shared DS 
        clientindex = 0
        dscgaid     = "2"
        capacity      = 1
        imc           = "MatchOuterVID"
        imc_outer_vid = "500"
        emc           = "None"
        emc_outer_vid = ""
      }
    },
    xr-regA_H2-L2 = {
      lc-xr-regA_H1-Hub-ds-1 = { // leaf 6 rcv <- hub, 100G shared DS 
        clientindex = 0
        dscgaid     = "1"
        capacity      = 4
        imc           = "None"
        imc_outer_vid = ""
        emc           = "MatchOuterVID"
        emc_outer_vid = "600"
      },
      lc-xr-regA_H1-Hub-us-1 = { // leaf 6 tx -> hub, 25G shared DS 
        clientindex = 0
        dscgaid     = "2"
        capacity      = 1
        imc           = "MatchOuterVID"
        imc_outer_vid = "600"
        emc           = "None"
        emc_outer_vid = ""
      }
    },
    xr-regA_H2-L3 = {
      lc-xr-regA_H1-Hub-ds-1 = { // leaf 7 rcv <- hub, 100G shared DS 
        clientindex = 0
        dscgaid     = "1"
        capacity      = 4
        imc           = "None"
        imc_outer_vid = ""
        emc           = "MatchOuterVID"
        emc_outer_vid = "700"
      },
      lc-xr-regA_H1-Hub-us-1 = { // leaf 7 tx -> hub, 25G shared DS 
        clientindex = 0
        dscgaid     = "2"
        capacity      = 1
        imc           = "MatchOuterVID"
        imc_outer_vid = "700"
        emc           = "None"
        emc_outer_vid = ""
      }
    },
    xr-regA_H2-L4 = {
      lc-xr-regA_H1-Hub-ds-1 = { // leaf 8 rcv <- hub, 100G shared DS 
        clientindex = 0
        dscgaid     = "1"
        capacity      = 4
        imc           = "None"
        imc_outer_vid = ""
        emc           = "MatchOuterVID"
        emc_outer_vid = "800"
      },
      lc-xr-regA_H1-Hub-us-1 = { // leaf 8 tx -> hub, 25G shared DS 
        clientindex = 0
        dscgaid     = "2"
        capacity      = 1
        imc           = "MatchOuterVID"
        imc_outer_vid = "800"
        emc           = "None"
        emc_outer_vid = ""
      }
    }
    xr-regA_H1-Hub = {
      lc-XR-SFO_12-1234-1-ds = { // hub tx -> leaf 1/2/3/4 - 100G Shared downstream
        clientindex = 0
        dscgaid     = "1"
        capacity      = 4
        imc           = "MatchAll"
        imc_outer_vid = ""
        emc           = "None"
        emc_outer_vid = ""
      },
      lc-xr-regA_H1-L1-1-us = { // hub rcv <- leaf 1, 25G US
        clientindex = 0
        dscgaid     = "3" // US DSCG ID      
        capacity      = 1
        imc           = "None"
        imc_outer_vid = ""
        emc           = "MatchOuterVID"
        emc_outer_vid = "100"
      },
      lc-xr-regA_H1-L2-1-us = { // hub rcv -> leaf 2, 25G US
        clientindex = 0
        dscgaid     = "4" //DS DSCG ID                 
        capacity      = 1
        imc           = "None"
        imc_outer_vid = ""
        emc           = "MatchOuterVID"
        emc_outer_vid = "200"
      },
      lc-xr-regA_H1-L3-1-us = { // hub rcv -> leaf 3, 25G US
        clientindex = 0
        dscgaid     = "6" //DS DSCG ID               
        capacity      = 1
        imc           = "None"
        imc_outer_vid = ""
        emc           = "MatchOuterVID"
        emc_outer_vid = "300"
      },
      lc-xr-regA_H1-L4-1-us = { // hub rcv -> leaf 4, 25G US
        clientindex = 0
        dscgaid     = "8" //DS DSCG ID               
        capacity      = 1
        imc           = "None"
        imc_outer_vid = ""
        emc           = "MatchOuterVID"
        emc_outer_vid = "400"
      },
      lc-XR-SFO_12-5678-1-ds = { // hub tx -> leaf 5/6/7/8 - 100G Shared downstream
        clientindex = 1
        dscgaid     = "2"
        capacity      = 4
        imc           = "MatchAll"
        imc_outer_vid = ""
        emc           = "None"
        emc_outer_vid = ""
      },
      lc-xr-regA_H2-L1-1-us = { // hub rcv <- leaf 5, 25G US
        clientindex = 1
        dscgaid     = "10" // US DSCG ID       
        capacity      = 1
        imc           = "None"
        imc_outer_vid = ""
        emc           = "MatchOuterVID"
        emc_outer_vid = "500"
      },
      lc-xr-regA_H2-L2-1-us = { // hub rcv -> leaf 6, 25G US
        clientindex = 1
        dscgaid     = "12" //DS DSCG ID             
        capacity      = 1
        imc           = "None"
        imc_outer_vid = ""
        emc           = "MatchOuterVID"
        emc_outer_vid = "600"
      },
      lc-xr-regA_H2-L3-1-us = { // hub rcv -> leaf 7, 25G US
        clientindex = 1
        dscgaid     = "14" //DS DSCG ID              
        capacity      = 1
        imc           = "None"
        imc_outer_vid = ""
        emc           = "MatchOuterVID"
        emc_outer_vid = "700"
      },
      lc-xr-regA_H2-L4-1-us = { // hub rcv -> leaf 8, 25G US   
        clientindex = 1
        dscgaid     = "16" //DS DSCG ID                
        capacity      = 1
        imc           = "None"
        imc_outer_vid = ""
        emc           = "MatchOuterVID"
        emc_outer_vid = "800"
      },
    }, // end Hub AC/LCs
    xr-regA_H1-L1 = {
      lc-xr-regA_H1-Hub-ds-1 = { // leaf 1 rcv <- hub, 100G shared DS 
        clientindex = 0
        dscgaid     = "1"
        capacity      = 4
        imc           = "None"
        imc_outer_vid = ""
        emc           = "MatchOuterVID"
        emc_outer_vid = "100"
      },
      lc-xr-regA_H1-Hub-us-1 = { // leaf 1 tx -> hub, 25G shared DS 
        clientindex = 0
        dscgaid     = "2"
        capacity      = 1
        imc           = "MatchOuterVID"
        imc_outer_vid = "100"
        emc           = "None"
        emc_outer_vid = ""
      }
    },
    xr-regA_H1-L2 = {
      lc-xr-regA_H1-Hub-ds-1 = { // leaf 2 rcv <- hub, 100G shared DS 
        clientindex = 0
        dscgaid     = "1"
        capacity      = 4
        imc           = "None"
        imc_outer_vid = ""
        emc           = "MatchOuterVID"
        emc_outer_vid = "200"
      },
      lc-xr-regA_H1-Hub-us-1 = { // leaf 2 tx -> hub, 25G shared DS 
        clientindex = 0
        dscgaid     = "2"
        capacity      = 1
        imc           = "MatchOuterVID"
        imc_outer_vid = "200"
        emc           = "None"
        emc_outer_vid = ""
      }
    },
    xr-regA_H1-L3 = {
      lc-xr-regA_H1-Hub-ds-1 = { // leaf 3 rcv <- hub, 100G shared DS 
        clientindex = 0
        dscgaid     = "1"
        capacity      = 4
        imc           = "None"
        imc_outer_vid = ""
        emc           = "MatchOuterVID"
        emc_outer_vid = "300"
      },
      lc-xr-regA_H1-Hub-us-1 = { // leaf 3 tx -> hub, 25G shared DS 
        clientindex = 0
        dscgaid     = "2"
        capacity      = 1
        imc           = "MatchOuterVID"
        imc_outer_vid = "300"
        emc           = "None"
        emc_outer_vid = ""
      }
    },
    xr-regA_H1-L4 = {
      lc-xr-regA_H1-Hub-ds-1 = { // leaf 4 rcv <- hub, 100G shared DS 
        clientindex = 0
        dscgaid     = "1"
        capacity      = 4
        imc           = "None"
        imc_outer_vid = ""
        emc           = "MatchOuterVID"
        emc_outer_vid = "400"
      },
      lc-xr-regA_H1-Hub-us-1 = { // leaf 4 tx -> hub, 25G shared DS 
        clientindex = 0
        dscgaid     = "2"
        capacity      = 1
        imc           = "MatchOuterVID"
        imc_outer_vid = "400"
        emc           = "None"
        emc_outer_vid = ""
      }
    },
    xr-regA_H2-L1 = {
      lc-xr-regA_H1-Hub-ds-1 = { // leaf 5 rcv <- hub, 100G shared DS 
        clientindex = 0
        dscgaid     = "1"
        capacity      = 4
        imc           = "None"
        imc_outer_vid = ""
        emc           = "MatchOuterVID"
        emc_outer_vid = "500"
      },
      lc-xr-regA_H1-Hub-us-1 = { // leaf 5 tx -> hub, 25G shared DS 
        clientindex = 0
        dscgaid     = "2"
        capacity      = 1
        imc           = "MatchOuterVID"
        imc_outer_vid = "500"
        emc           = "None"
        emc_outer_vid = ""
      }
    },
    xr-regA_H2-L2 = {
      lc-xr-regA_H1-Hub-ds-1 = { // leaf 6 rcv <- hub, 100G shared DS 
        clientindex = 0
        dscgaid     = "1"
        capacity      = 4
        imc           = "None"
        imc_outer_vid = ""
        emc           = "MatchOuterVID"
        emc_outer_vid = "600"
      },
      lc-xr-regA_H1-Hub-us-1 = { // leaf 6 tx -> hub, 25G shared DS 
        clientindex = 0
        dscgaid     = "2"
        capacity      = 1
        imc           = "MatchOuterVID"
        imc_outer_vid = "600"
        emc           = "None"
        emc_outer_vid = ""
      }
    },
    xr-regA_H2-L3 = {
      lc-xr-regA_H1-Hub-ds-1 = { // leaf 7 rcv <- hub, 100G shared DS 
        clientindex = 0
        dscgaid     = "1"
        capacity      = 4
        imc           = "None"
        imc_outer_vid = ""
        emc           = "MatchOuterVID"
        emc_outer_vid = "700"
      },
      lc-xr-regA_H1-Hub-us-1 = { // leaf 7 tx -> hub, 25G shared DS 
        clientindex = 0
        dscgaid     = "2"
        capacity      = 1
        imc           = "MatchOuterVID"
        imc_outer_vid = "700"
        emc           = "None"
        emc_outer_vid = ""
      }
    },
    xr-regA_H2-L4 = {
      lc-xr-regA_H1-Hub-ds-1 = { // leaf 8 rcv <- hub, 100G shared DS 
        clientindex = 0
        dscgaid     = "1"
        capacity      = 4
        imc           = "None"
        imc_outer_vid = ""
        emc           = "MatchOuterVID"
        emc_outer_vid = "800"
      },
      lc-xr-regA_H1-Hub-us-1 = { // leaf 8 tx -> hub, 25G shared DS 
        clientindex = 0
        dscgaid     = "2"
        capacity      = 1
        imc           = "MatchOuterVID"
        imc_outer_vid = "800"
        emc           = "None"
        emc_outer_vid = ""
      }
    }
  }
}
