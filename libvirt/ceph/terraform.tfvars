project               = "ceph"
domain                = "oikia.local"
node_name             = "node"
node_count            = 3
use_proxy             = true

proxy = {
  scheme  = "http"
  ip_addr = "172.16.1.1"
  port    = "3128"
}

node = {
  os_distro      = "ubuntu"
  os_release     = "20.04"
  memory         = 4*1024
  vcpu           = 2
  os_disk_size   = 40*1024*1024*1024
  stor_disk_size = 20*1024*1024*1024
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
    ip_offset            = 40
  }

  storage = {
    libvirt_name         = "ovs-stor"
    libvirt_uuid         = "cdca9107-08a4-4958-bd52-41578b6a9f2c"
    host_bridge          = "br-stor"
    subnet               = "172.16.2.0/24"
    ip_offset            = 30
  }
}
