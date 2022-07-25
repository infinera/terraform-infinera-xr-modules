variable "client-2-dscg" {
  type = map(map(object({
    clientid = string
    dscgid   = string
  })))
  description = "Defines the local connections for each node in the network. each conection include the cliend id and dscg id"
}