# Introduction

To create a L1 or L2 XR Network, please follow these steps below:

1. Clone [Use Git Repo](https://github.com/infinera/terraform-xr-network-setup/tree/main/use-git-Repo)
   
2. Set credential to access to XR network
   a. By update *required_provider.tf*
   b. Or define the following TF environment varibles
   ` export TF_VAR-user = AAA `
   ` export TF_VAR-password = BBB `
   ` export TF_VAR-host = a.b.c.d:port `
   
3. Specify the type of XR Network to setup in input tfvars file. 
   `var trafficmode = "L1Mode|L2Mode"`

4. Run terraform commands with the input tfvars file
`Terraform -apply -var-file="aaa.tfvars`
`Terraform -destroy -var-file="aaa.tfvars`

For sample of the input tfvars files, please refer to the [examples](https://github.com/infinera/terraform-xr-network-setup/tree/main/examples)
