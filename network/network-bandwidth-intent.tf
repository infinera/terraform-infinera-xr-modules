// Hub Bandwidth
// 
variable "hub_bandwidth" {
  type = map(map(object({
    hubdscgid     = string
    leafdscgid    = string
    hubdscidlist  = list(string)
    leafdscidlist = list(string)
    direction     = string // possible values: bidi, us, ds
  })))
  description = "Defines the bandwidth to provisioned between Hub and each leaf. For each leaf, define the hub dscids to be assigned to the BW, and the hubdscgid and leafdscgid to be use to create the DSCG. Creates Hub and Leaf DSCGs"
  default = {

    xr-regA_H1-Hub = { // For each DSCG create a entry, ds = hubdscidlist, us = leafdscidlist. 
      // for each dsc specified in hubdscidlist THD tx, rx enabled
      xr-regA_H1-Hub-BW5173ds = { hubdscgid = "1", leafdscgid = "1", hubdscidlist = ["5", "1", "7", "3"], leafdscidlist = ["1", "2", "3", "4"], direction = "ds" }
      xr-regA_H1-Hub-BW2468ds = { hubdscgid = "2", leafdscgid = "1", hubdscidlist = ["2", "4", "6", "8"], leafdscidlist = ["1", "2", "3", "4"], direction = "ds" },
    },
  }
}

// Leaf Bandwidth
variable "leaf_bandwidth" {
  // type        = map(map(list(string)))
  type = map(map(object({
    hubdscgid     = string
    leafdscgid    = string
    hubdscidlist  = list(string)
    leafdscidlist = list(string)
    direction     = string // possible values: bidi, us, ds
  })))
  description = "Defines the bandwidth to provisioned between Hub and each leaf. For each leaf, define the hub dscids to be assigned to the BW, and the hubdscgid and leafdscgid to be use to create the DSCG. Creates Hub and Leaf DSCGs"
  default = {
    xr-regA_H1-L1 = {       
      xr-regA_H1-Hub-BW5173ds = { hubdscgid = "3", leafdscgid = "2", hubdscidlist = ["5"], leafdscidlist = ["1"], direction = "us" }
    }
    xr-regA_H1-L2 = {
       xr-regA_H1-Hub-BW5173ds = { hubdscgid = "4", leafdscgid = "2", hubdscidlist = ["1"], leafdscidlist = ["1"], direction = "us" }
    }
    xr-regA_H1-L3 = {
       xr-regA_H1-Hub-BW5173ds = { hubdscgid = "6", leafdscgid = "2", hubdscidlist = ["7"], leafdscidlist = ["1"], direction = "us" }
    }
    xr-regA_H1-L4 = {
      xr-regA_H1-Hub-BW5173ds = { hubdscgid = "8", leafdscgid = "2", hubdscidlist = ["3"], leafdscidlist = ["1"], direction = "us" }
    }

    xr-regA_H2-L1 = {
       xr-regA_H1-Hub-BW2468ds = { hubdscgid = "10", leafdscgid = "2", hubdscidlist = ["2"], leafdscidlist = ["1"], direction = "us" }
    }
    xr-regA_H2-L2 = {
      xr-regA_H1-Hub-BW2468ds = { hubdscgid = "12", leafdscgid = "2", hubdscidlist = ["4"], leafdscidlist = ["1"], direction = "us" }
    }
    xr-regA_H2-L3 = {
      xr-regA_H1-Hub-BW2468ds = { hubdscgid = "14", leafdscgid = "2", hubdscidlist = ["6"], leafdscidlist = ["1"], direction = "us" }
    }
    xr-regA_H2-L4 = {
      xr-regA_H1-Hub-BW2468ds = { hubdscgid = "16", leafdscgid = "2", hubdscidlist = ["8"], leafdscidlist = ["1"], direction = "us" }

    }
  }
}