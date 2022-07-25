
variable "leaf-2-hub-dscids" {
  // type        = map(map(list(string)))
  type = map(map(object({
    hubdscgid     = string
    leafdscgid    = string
    hubdscidlist  = list(string)
    leafdscidlist = list(string) 
  })))
  description = "Defines the bandwidth to provisioned between Hub and each leaf. For each leaf, define the hub dscids to be assigned to the BW, and the hubdscgid and leafdscgid to be use to create the DSCG. Creates Hub and Leaf DSCGs"
}

