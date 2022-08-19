
module "device-dscs" {
  source = "./dscs"

  count     = length(var.dscstest)
  n         = var.dscstest[count.index]["name"]
  lineptpid = var.lineptpid
  carrierid = var.carrierid
  dscstest = var.dscstest[count.index]
}
