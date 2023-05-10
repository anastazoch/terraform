terraform {
  required_version = ">= 1.2.3"
    required_providers {
      libvirt = {
        source  = "dmacvicar/libvirt"
        version = "0.7.1"
     }
   }
}