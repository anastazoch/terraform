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