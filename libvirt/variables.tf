locals {
  controller_name = "openstack-controller"
  compute_name = "openstack-compute"

  networks = {
    external = {
      libvirt_net          = "ovs-ex",
      host_bridge          = "br-ex"
      subnet               = "192.168.132.0/24"
      ip_offset_controller = 10,
      ip_offset_compute    = 20
    },
    management = {
      libvirt_net          = "ovs-mgmt",
      host_bridge          = "br-mgmt"
      subnet               = "172.16.1.0/24"
      ip_offset_controller = 10,
      ip_offset_compute    = 20
    },
    storage = {
      libvirt_net          = "ovs-storage",
      host_bridge          = "br-storage"
      subnet               = "172.16.2.0/24"
      ip_offset_controller = 10,
      ip_offset_compute    = 20
    },
    vxlan = {
      libvirt_net          = "ovs-vxlan",
      host_bridge          = "br-vxlan"
      subnet               = "172.16.3.0/24"
      ip_offset_controller = 10,
      ip_offset_compute    = 20
    },
    vlan = {
      libvirt_net          = "ovs-vlan",
      host_bridge          = "br-vlan"
      subnet               = "172.16.4.0/24"
      ip_offset_controller = 10,
      ip_offset_compute    = 20
    }
  }
}

variable "controller_node_count" {
  type = number
  default = 2
  description = "number of controller nodes (controller, network)"
}

variable "compute_node_count" {
  type = number
  default = 3
  description = "number of compute nodes (compute)"
}

variable controller_node {
  type = object({
    os_distro     = string
    os_release    = string
    memory        = number
    vcpu          = number
    os_disk_size  = number
    networks      = list(string)
    qemu_agent    = bool
  })
}

variable compute_node {
  type = object({
    os_distro          = string
    os_release         = string
    memory             = number
    vcpu               = number
    os_disk_size       = number
    stor_disk_size     = number
    networks           = list(string)
    qemu_agent         = bool
  })
}