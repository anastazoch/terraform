resource "libvirt_cloudinit_disk" "cloudinit_iso" {
  name      = "cloudinit.iso"
  user_data = data.template_file.cloud_init_config
}

data "template_file" "cloud_init_config" {
  template = var.os_distro == 'ubuntu' && var.os_release == '20.04' ? ' ? file("${path.module}/cloud_init_ubuntu_20.04.cfg")  : var.os_distro == 'ubuntu' && var.os_release == '22.04' ? file("${path.module}/cloud_init_ubuntu_22.04.cfg")  : var.os_distro == 'centos' && var.os_release == '8' ? file("${path.module}/cloud_init_centos_8.cfg")  : var.os_distro == 'centos' && var.os_release == '9' ? file("${path.module}/cloud_init_centos_9.cfg")
}

resource "libvirt_volume" "os_image" {
  name   = "ubuntu-qcow2"
  pool   = "default"
  source = var.os_distro == 'ubuntu' && var.os_release == '20.04' ? ' ? "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64-disk-kvm.img" ' : var.os_distro == 'ubuntu' && var.os_release == '22.04' ? "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64-disk-kvm.img" : var.os_distro == 'centos' && var.os_release == '8' ? "https://cloud.centos.org/centos/8/x86_64/images/CentOS-8-GenericCloud-8.4.2105-20210603.0.x86_64.qcow2" : var.os_distro == 'centos' && var.os_release == '9' ? "https://cloud.centos.org/centos/9-stream/x86_64/images/CentOS-Stream-GenericCloud-9-20230327.0.x86_64.qcow2"
  format = "qcow2"
}

resource "libvirt_domain" "master_node" {
  count  = var.num_of_masters
  name   = "openstack-master-${count.index}"
  memory = var.master_mem
  vcpu   = var.master_cpu_cores

  cloudinit = libvirt_cloudinit_disk.

  network_interface {
    network_name = "ovs-ex"
  }

  network_interface {
    network_name = "ovs-mgmt"
  }

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

  disk {
    volume_id = libvirt_volume.master_main_disk[count.index].id
  }
}

resource "libvirt_domain" "worker_node" {
  count  = var.worker_count
  name   = "openstack-worker-"
  memory = "512"
  vcpu   = 1

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  network_interface {
    network_name = "default"
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

  disk {
    volume_id = libvirt_volume.ubuntu-qcow2.id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}