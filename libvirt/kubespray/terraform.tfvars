project               = "kubespray"
domain                = "oikia.local"
node_name             = "node"
node_count            = 5
use_proxy             = true

proxy = {
  scheme  = "http"
  ip_addr = "172.16.1.1"
  port    = "3128"
}

node = {
  os_distro      = "almalinux"
  os_release     = "8.5"
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
    ip_offset            = 30
  }
}
