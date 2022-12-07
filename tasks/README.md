# Tasks
**These tasks are used to configure and maintain the constellation networks. More tasks shall be defined and added.**

## Network Task
Use this task to setup a network with optional condition checks and filters. Please see the corresponding [network](https://github.com/infinera/terraform-infinera-xr-modules/tree/main/tasks/network) task for more details.

## Network Attribute Check
Use this task to check for attribute with matching specified conditions in the existing constellation network. Please see the corresponding [network_attribute_check](https://github.com/infinera/terraform-infinera-xr-modules/tree/main/tasks/network_attribute_check) task for more details.

## Network Host Mismatched Attribute Check
Use this task to check for mismatched host attributes in the existing constellation network. Please see the corresponding [network_host_mismatch_attribute_check](https://github.com/infinera/terraform-infinera-xr-modules/tree/main/tasks/network_host_mismatch_attribute_check) task for more details.

## Network With IDs Check
Use this task to check for any devices with different IDs b/t the network and the current TF State in the existing constellation network. Please see the corresponding [network_with_IDs_check](https://github.com/infinera/terraform-infinera-xr-modules/tree/main/tasks/network_with_IDs_check) task for more details.

## Network With Version Check
Use this task to check for Devices with mismatched version b/t network and intent. Please see the corresponding [network_with_versions_check](https://github.com/infinera/terraform-infinera-xr-modules/tree/main/tasks/network_with_versions_check) task for more details.