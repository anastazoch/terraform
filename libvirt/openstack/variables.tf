variable "project" {
  type        = string
  description = "Name of the project, e.g. openstack"
}              

variable "domain" {
  type        = string
  description = "Domain name, e.g. mydomain.local"
}          

variable "use_proxy" {
  type        = bool
  default     = false
  description = "Use or not a proxy"
}

variable "proxy" {
  type = object({
    scheme  = string
    ip_addr = string
    port    = string
  })
}

variable "controller_name" {
  type = string
}

variable "controller_node_count" {
  type        = number
  default     = 2
  description = "number of controller nodes (controller, network)"
}

variable "compute_name" {
  type = string
}

variable "compute_node_count" {
  type        = number
  default     = 3
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

variable networks {
  type = object({
      management = object({
          libvirt_name         = string
          libvirt_uuid         = string
          host_bridge          = string
          subnet               = string
          gateway              = string
          nameservers          = list(string)
          ip_offset_controller = number
          ip_offset_compute    = number
      })
      storage = object({
          libvirt_name         = string
          libvirt_uuid         = string
          host_bridge          = string
          subnet               = string
          ip_offset_controller = number
          ip_offset_compute    = number
      })
      vxlan = object({
          libvirt_name         = string
          libvirt_uuid         = string
          host_bridge          = string
          subnet               = string
          ip_offset_controller = number
          ip_offset_compute    = number
      })
      vlan = object({
          libvirt_name         = string
          libvirt_uuid         = string
          host_bridge          = string
          subnet               = string
          ip_offset_controller = number
          ip_offset_compute    = number
      })
  })
}