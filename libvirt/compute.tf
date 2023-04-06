resource "libvirt_domain" "controller_node" {
  count     = var.controller_node_count
  name      = "${local.controller_name}-${count.index + 1}"
  memory    = var.controller_node.memory
  vcpu      = var.controller_node.vcpu
  autostart = false

  cloudinit = libvirt_cloudinit_disk.controller_cloudinit_iso[count.index].id

  disk {
    volume_id = element(libvirt_volume.controller_os_volume.*.id, count.index)
  }

  network_interface {
    #network_name = libvirt_network.ovs_external.id
    network_name = local.networks["external"]["libvirt_name"]
    addresses  = ["${cidrhost(local.networks["external"]["subnet"], local.networks["external"]["ip_offset_controller"] + count.index + 1)}"]
    wait_for_lease = false
  }

  network_interface {
    #network_name = libvirt_network.ovs_management.id
    network_name = local.networks["management"]["libvirt_name"]
    addresses  = ["${cidrhost(local.networks["management"]["subnet"], local.networks["management"]["ip_offset_controller"] + count.index + 1)}"]
    wait_for_lease = false
  }

  network_interface {
    #network_name = libvirt_network.ovs_stor.id
    network_name = local.networks["storage"]["libvirt_name"]
    addresses  = ["${cidrhost(local.networks["storage"]["subnet"], local.networks["storage"]["ip_offset_controller"] + count.index + 1)}"]
    wait_for_lease = false
  }

  network_interface {
    #network_name = libvirt_network.ovs_vxlan.id
    network_name = local.networks["vxlan"]["libvirt_name"]
    addresses  = ["${cidrhost(local.networks["vxlan"]["subnet"], local.networks["vxlan"]["ip_offset_controller"] + count.index + 1)}"]
    wait_for_lease = false
  }

  network_interface {
    #network_name = libvirt_network.ovs_vlan.id
    network_name = local.networks["vlan"]["libvirt_name"]
    addresses  = ["${cidrhost(local.networks["vlan"]["subnet"], local.networks["vlan"]["ip_offset_controller"] + count.index + 1)}"]
    wait_for_lease = false
  }

  # IMPORTANT: this is a known bug on cloud images, since they expect a console
  # we need to pass it
  # https://bugs.launchpad.net/cloud-images/+bug/1573095
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  qemu_agent = var.controller_node.qemu_agent
}

resource "libvirt_domain" "compute_node" {
  count  = var.compute_node_count
  name   = "${local.compute_name}-${count.index + 1}"
  memory = var.compute_node.memory
  vcpu   = var.compute_node.vcpu
  autostart = false

  cloudinit = libvirt_cloudinit_disk.compute_cloudinit_iso[count.index].id

  disk {
    volume_id = element(libvirt_volume.compute_os_volume.*.id, count.index)
  }

  disk {
    volume_id = element(libvirt_volume.compute_first_stor_volume.*.id, count.index)
  }

  network_interface {
    #network_name = libvirt_network.ovs_external.id
    network_name = local.networks["external"]["libvirt_name"]
    addresses  = ["${cidrhost(local.networks["external"]["subnet"], local.networks["external"]["ip_offset_compute"] + count.index + 1)}"]
    wait_for_lease = false
  }

  network_interface {
    #network_name = libvirt_network.ovs_management.id
    network_name = local.networks["management"]["libvirt_name"]
    addresses  = ["${cidrhost(local.networks["management"]["subnet"], local.networks["management"]["ip_offset_compute"] + count.index + 1)}"]
    wait_for_lease = false
  }

  network_interface {
    #network_name = libvirt_network.ovs_stor.id
    network_name = local.networks["storage"]["libvirt_name"]
    addresses  = ["${cidrhost(local.networks["storage"]["subnet"], local.networks["storage"]["ip_offset_compute"] + count.index + 1)}"]
    wait_for_lease = false
  }

  network_interface {
    #network_name = libvirt_network.ovs_vxlan.id
    network_name = local.networks["vxlan"]["libvirt_name"]
    addresses  = ["${cidrhost(local.networks["vxlan"]["subnet"], local.networks["vxlan"]["ip_offset_compute"] + count.index + 1)}"]
    wait_for_lease = false
  }

  network_interface {
    #network_name = libvirt_network.ovs_vlan.id
    network_name = local.networks["vlan"]["libvirt_name"]
    addresses  = ["${cidrhost(local.networks["vlan"]["subnet"], local.networks["vlan"]["ip_offset_compute"] + count.index + 1)}"]
    wait_for_lease = false
  }

  # IMPORTANT: this is a known bug on cloud images, since they expect a console
  # we need to pass it
  # https://bugs.launchpad.net/cloud-images/+bug/1573095
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }

  qemu_agent = var.compute_node.qemu_agent
}