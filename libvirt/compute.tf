resource "libvirt_domain" "controller_node" {
  count  = var.controller_node_count
  name   = "${local.compute_name}-${count.index + 1}"
  memory = var.controller_node.memory
  vcpu   = var.controller_node.vcpu

  cloudinit = libvirt_cloudinit_disk.controller_cloudinit_iso.id

  disk {
    volume_id = element(libvirt_volume.controller_os_volume.*.id, count.index)
  }

  network_interface {
    network_id = libvirt_network.ovs_external.id
    addresses  = ["${cidrhost(local.networks["external"]["subnet"], local.networks["external"]["ip_offset_controller"] + count.index + 1)}"]
  }

  network_interface {
    network_id = libvirt_network.ovs_management.id
    addresses  = ["${cidrhost(local.networks["management"]["subnet"], local.networks["management"]["ip_offset_controller"] + count.index + 1)}"]
  }

  network_interface {
    network_id = libvirt_network.ovs_storage.id
    addresses  = ["${cidrhost(local.networks["storage"]["subnet"], local.networks["storage"]["ip_offset_controller"] + count.index + 1)}"]
  }

  network_interface {
    network_id = libvirt_network.ovs_vxlan.id
    addresses  = ["${cidrhost(local.networks["vxlan"]["subnet"], local.networks["vxlan"]["ip_offset_controller"] + count.index + 1)}"]
  }

  network_interface {
    network_id = libvirt_network.ovs_vlan.id
    addresses  = ["${cidrhost(local.networks["vlan"]["subnet"], local.networks["vlan"]["ip_offset_controller"] + count.index + 1)}"]
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
  memory = var.controller_node.memory
  vcpu   = var.controller_node.vcpu

  cloudinit = libvirt_cloudinit_disk.compute_cloudinit_iso.id

  disk {
    volume_id = element(libvirt_volume.compute_os_volume.*.id, count.index)
  }

  disk {
    volume_id = element(libvirt_volume.compute_first_storage_volume.*.id, count.index)
  }

  network_interface {
    network_id = libvirt_network.ovs_external.id
    addresses  = ["${cidrhost(local.networks["external"]["subnet"], local.networks["external"]["ip_offset_compute"] + count.index + 1)}"]
  }

  network_interface {
    network_id = libvirt_network.ovs_management.id
    addresses  = ["${cidrhost(local.networks["management"]["subnet"], local.networks["management"]["ip_offset_compute"] + count.index + 1)}"]
  }

  network_interface {
    network_id = libvirt_network.ovs_storage.id
    addresses  = ["${cidrhost(local.networks["storage"]["subnet"], local.networks["storage"]["ip_offset_compute"] + count.index + 1)}"]
  }

  network_interface {
    network_id = libvirt_network.ovs_vxlan.id
    addresses  = ["${cidrhost(local.networks["vxlan"]["subnet"], local.networks["vxlan"]["ip_offset_compute"] + count.index + 1)}"]
  }

  network_interface {
    network_id = libvirt_network.ovs_vlan.id
    addresses  = ["${cidrhost(local.networks["vlan"]["subnet"], local.networks["vlan"]["ip_offset_compute"] + count.index + 1)}"]
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