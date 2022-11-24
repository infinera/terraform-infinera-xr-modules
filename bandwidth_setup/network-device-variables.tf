
variable "hub_names" {
  type    = list(string)
  description = "Add hub name, only one entry supported"
}

// TODO : Add New Leaf
// TODO : remove leaf; Cascaded Delete

// Leaf names
variable "leaf_names" {
  type = list(string)
  description = "Add/Remove - leaf_names - upto 16 entires"
}



