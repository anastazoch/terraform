controller_node_count = 2
compute_node_count    = 3

controller_node = {
  os_distro      = "ubuntu"
  os_release     = "20.04"
  memory         = 2048
  vcpu           = 2
  os_disk_size   = 21474836480
  networks       = ["external", "management", "storage", "vxlan", "vlan"]
  qemu_agent     = true
}

compute_node = {
  os_distro      = "ubuntu"
  os_release     = "20.04"
  memory         = 2048
  vcpu           = 2
  os_disk_size   = 21474836480
  stor_disk_size = 21474836480
  networks       = ["external", "management", "storage", "vxlan", "vlan"]
  qemu_agent     = true
}