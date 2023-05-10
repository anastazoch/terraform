resource "libvirt_domain" "kube_node" {
  count  = var.node_count
  name   = "${format("%s%02s", local.node_name_prefix, count.index + 1)}"
  memory = var.node.memory
  vcpu   = var.node.vcpu
  autostart = false

  cloudinit = libvirt_cloudinit_disk.cloudinit_iso[count.index].id

  disk {
    volume_id = element(libvirt_volume.os_volume.*.id, count.index)
  }

  disk {
    volume_id = element(libvirt_volume.first_stor_volume.*.id, count.index)
  }

  disk {
    volume_id = element(libvirt_volume.second_stor_volume.*.id, count.index)
  }

  network_interface {
    #network_name = libvirt_network.ovs_management.id
    network_name = var.networks["management"]["libvirt_name"]
    wait_for_lease = false
  }

  network_interface {
    #network_name = libvirt_network.ovs_management.id
    network_name = var.networks["management"]["libvirt_name"]
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

  qemu_agent = var.node.qemu_agent
}