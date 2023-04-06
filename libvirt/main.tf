locals {
  domain          = "oikia.local"
  controller_name = "openstack-controller"
  compute_name    = "openstack-compute"

  networks = {
    external = {
      libvirt_name         = "ovs-ex"
      libvirt_uuid         = "a08771d5-6a19-400f-9ab9-cc5794a800f9"
      host_bridge          = "br-ex"
      subnet               = "192.168.132.0/24"
      ip_offset_controller = 10
      ip_offset_compute    = 20
    },
    management = {
      libvirt_name         = "ovs-mgmt"
      libvirt_uuid         = "4452dd17-a242-4bf9-ba40-ebd454dd98b1"
      host_bridge          = "br-mgmt"
      subnet               = "172.16.1.0/24"
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
}

