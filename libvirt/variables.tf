locals {
  master_name = "openstack-master"
  worker_name = "openstack-worker"
}

variable "master_count" {
  type = number
  default = 2
  description = "number of master nodes (controller, network)"
}

variable "worker_count" {
  type = number
  default = 3
  description = "number of worker nodes (compute)"
}

variable "os_distro" {
  type = string
  default = "ubuntu"
  description = "Distribution of the operating system of each node"
}

variable "os_release" {
  type = string
  default = "20.04"
  description = "Version of the operating system of each node"
}

variable "os_disk_size" {
  type = number
  default = 21474836480
  describe = "OS disk size in bytes"
}

variable storage_disk_size {
  type = number
  default = 21474836480
  description = "size of each disk allocated to Ceph in bytes"
}

variable 