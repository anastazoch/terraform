#resource "libvirt_network" "ovs_external" {
#  name   = local.networks["external"]["libvirt_net"]
#  mode   = "bridge"
#  bridge = local.networks["external"]["host_bridge"]
#}

#resource "libvirt_network" "ovs_management" {
#  name = local.networks["management"]["libvirt_net"]
#  mode = "bridge"
#  bridge = local.networks["management"]["host_bridge"]
#}

#resource "libvirt_network" "ovs_stor" {
#  name = local.networks["storage"]["libvirt_net"]
#  mode = "bridge"
#  bridge = local.networks["storage"]["host_bridge"]
#}

#resource "libvirt_network" "ovs_vxlan" {
#  name = local.networks["vxlan"]["libvirt_net"]
#  mode = "bridge"
#  bridge = local.networks["vxlan"]["host_bridge"]
#}

#resource "libvirt_network" "ovs_vlan" {
#  name = local.networks["vlan"]["libvirt_net"]
#  mode = "bridge"
#  bridge = local.networks["vlan"]["host_bridge"]
#}