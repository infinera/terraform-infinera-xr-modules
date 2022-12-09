# Terraform XR Modules
## Introduction
This are the Terraform XR Modules for L1/L2 XR Network Configuration, Provision and diagnostic tests 
1. [Workflows](https://github.com/infinera/terraform-infinera-xr-modules/tree/main/workflows): The XR Network workflow shall support configuration and provision the XR Network. They are implemented using the XR Network tasks.
2. [Tasks](https://github.com/infinera/terraform-infinera-xr-modules/tree/main/tasks): The XR Network tasks are the building blocks to construct the XR Network Workflows. They are implemented using the common utils module.
3. [Utils](https://github.com/infinera/terraform-infinera-xr-modules/tree/main/utils): It has all common util module which are used to build the tasks or workflows.
4. [Preconditions](https://github.com/infinera/terraform-infinera-xr-modules/tree/main/preconditions): TBD
5. [Postconditions] TBD
6. [Bandwidth Setup](https://github.com/infinera/terraform-infinera-xr-modules/tree/main/bandwidth-setup): Modules to setup the XR Network Bandwidth.
7. [Network Setup](https://github.com/infinera/terraform-infinera-xr-modules/tree/main/network-setup): Modules to setup the XR Network devices.
8. [Service Setup](https://github.com/infinera/terraform-infinera-xr-modules/tree/main/service-setup): Modules to setup the XR Network Services.
9.  Diagnostic Tests
    1.  [Carrier Diagnostic](https://github.com/infinera/terraform-infinera-xr-modules/tree/main/diagnostic/carrier-diag)
    2.  [DSC Diagnostic](https://github.com/infinera/terraform-infinera-xr-modules/tree/main/diagnostic/dscs-diag)
    3.  [Ethernet Loopback](https://github.com/infinera/terraform-infinera-xr-modules/tree/main/diagnostic/ethernet-loopback-diag)
## Usage References
* [Terraform XR Network](https://github.com/infinera/terraform-xr-network) The Terraform XR Network use cases in this repository are implemented using the terraform XR modules.
