#resource "libvirt_network" "ovs_management" {
#  name = var.networks["management"]["libvirt_net"]
#  mode = "bridge"
#  bridge = var.networks["management"]["host_bridge"]
#}

#resource "libvirt_network" "ovs_stor" {
#  name = var.networks["storage"]["libvirt_net"]
#  mode = "bridge"
#  bridge = var.networks["storage"]["host_bridge"]
#}

#resource "libvirt_network" "ovs_vxlan" {
#  name = var.networks["vxlan"]["libvirt_net"]
#  mode = "bridge"
#  bridge = var.networks["vxlan"]["host_bridge"]
#}

#resource "libvirt_network" "ovs_vlan" {
#  name = var.networks["vlan"]["libvirt_net"]
#  mode = "bridge"
#  bridge = var.networks["vlan"]["host_bridge"]
#}