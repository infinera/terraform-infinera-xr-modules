
variable "n" {
  type    = string
  default = "1"
}

variable "lineptpid" {
  type    = string
  default = "1"
}

variable "carrierid" {
  type    = string
  default = "1"
}

variable "dscstest" {
  type =list(object({
    name = string
    dscids = list(string)
    facprbsgen = string
    facprbsmon = string
  }))
  description = "Defines the dsc test between Hub and each leaf"
  default = [
      { name="xr-regA_H1-Hub", dscids= ["1", "2", "3", "4", "5"],  facprbsgen = "true", facprbsmon = "true" },
      { name="xr-regA_H1-L1", dscids= ["1", "2", "3", "4", "5"], facprbsgen = "true", facprbsmon = "true" },
      { name="xr-regA_H1-L2", dscids= ["1", "2", "3", "4", "5"], facprbsgen = "true", facprbsmon = "true" },
      { name="xr-regA_H1-L3", dscids= ["1", "2", "3", "4", "5"], facprbsgen = "true", facprbsmon = "true" },
    ]
}