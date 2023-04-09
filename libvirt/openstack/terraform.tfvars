project               = "openstack"
domain                = "oikia.local"
controller_name       = "controller"
compute_name          = "compute"
controller_node_count = 2
compute_node_count    = 3
use_proxy             = true

proxy = {
  scheme  = "http"
  ip_addr = "172.16.1.1"
  port    = "3128"
}

controller_node = {
  os_distro      = "ubuntu"
  os_release     = "20.04"
  memory         = 2*1024
  vcpu           = 2
  os_disk_size   = 20*1024*1024*1024
  networks       = ["management", "stor", "vxlan", "vlan"]
  qemu_agent     = true
}

compute_node = {
  os_distro      = "ubuntu"
  os_release     = "20.04"
  memory         = 2*1024
  vcpu           = 2
  os_disk_size   = 20*1024*1024*1024
  stor_disk_size = 20*1024*1024*1024
  networks       = ["management", "stor", "vxlan", "vlan"]
  qemu_agent     = true
}

networks = {
  management = {
    libvirt_name         = "ovs-mgmt"
    libvirt_uuid         = "4452dd17-a242-4bf9-ba40-ebd454dd98b1"
    host_bridge          = "br-mgmt"
    subnet               = "172.16.1.0/24"
    gateway              = "172.16.1.1"
    nameservers          = ["172.16.1.1"]
    ip_offset_controller = 10
    ip_offset_compute    = 20
  },
  storage = {
    libvirt_name         = "ovs-stor"
    libvirt_uuid         = "cdca9107-08a4-4958-bd52-41578b6a9f2c"
    host_bridge          = "br-stor"
    subnet               = "172.16.2.0/24"
    ip_offset_controller = 10
    ip_offset_compute    = 20
  },
  vxlan = {
    libvirt_name         = "ovs-vxlan"
    libvirt_uuid         = "d8eceaac-ad34-4b95-b801-a8e24cdbfabc"
    host_bridge          = "br-vxlan"
    subnet               = "172.16.3.0/24"
    ip_offset_controller = 10
    ip_offset_compute    = 20
  },
  vlan = {
    libvirt_name         = "ovs-vlan"
    libvirt_uuid         = "f3ad638a-df33-45cd-8542-14995bf78659"
    host_bridge          = "br-vlan"
    subnet               = "172.16.4.0/24"
    ip_offset_controller = 10
    ip_offset_compute    = 20
  }
}
