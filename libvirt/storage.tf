data "template_file" "controller_cloud_init_config" {
  count    = var.controller_node_count
  template = var.controller_node["os_distro"] == "ubuntu" && var.controller_node["os_release"] == "20.04" ? file("${path.module}/cloud_init_ubuntu_20.04.cfg") : var.controller_node["os_distro"] == "ubuntu" && var.controller_node["os_release"] == "22.04" ? file("${path.module}/cloud_init_ubuntu_22.04.cfg") : var.controller_node["os_distro"] == "centos" && var.controller_node["os_release"] == "8" ? file("${path.module}/cloud_init_centos_8.cfg") : var.controller_node["os_distro"] == "centos" && var.controller_node["os_release"] == "9" ? file("${path.module}/cloud_init_centos_9.cfg") : ""

  vars = {
    hostname = "${local.controller_name}-${count.index + 1}.${local.domain}"
  }
}

data "template_file" "compute_cloud_init_config" {
  count    = var.compute_node_count
  template = var.controller_node["os_distro"] == "ubuntu" && var.controller_node["os_release"] == "20.04" ? file("${path.module}/cloud_init_ubuntu_20.04.cfg") : var.controller_node["os_distro"] == "ubuntu" && var.controller_node["os_release"] == "22.04" ? file("${path.module}/cloud_init_ubuntu_22.04.cfg") : var.controller_node["os_distro"] == "centos" && var.controller_node["os_release"] == "8" ? file("${path.module}/cloud_init_centos_8.cfg") : var.controller_node["os_distro"] == "centos" && var.controller_node["os_release"] == "9" ? file("${path.module}/cloud_init_centos_9.cfg") : ""

  vars = {
    hostname = "${local.compute_name}-${count.index + 1}.${local.domain}"
  }
}

data "template_file" "network_config" {
  template = var.controller_node["os_distro"] == "ubuntu" ? file("${path.module}/network_ubuntu.cfg") : var.controller_node["os_distro"] == "centos" ? file("${path.module}/network_centos.cfg") : ""
}

resource "libvirt_cloudinit_disk" "controller_cloudinit_iso" {
  count          = var.controller_node_count
  name           = "cloud_init.iso"
  user_data      = element(data.template_file.controller_cloud_init_config.*.rendered, count.index)
  network_config = data.template_file.network_config.rendered
}

resource "libvirt_cloudinit_disk" "compute_cloudinit_iso" {
  count          = var.compute_node_count
  name           = "cloud_init.iso"
  user_data      = element(data.template_file.compute_cloud_init_config.*.rendered, count.index)
  network_config = data.template_file.network_config.rendered
}

resource "libvirt_volume" "cloud_init_volume" {
  name   = "cloud_init_volume"
  pool   = "default"
  source = var.controller_node["os_distro"] == "ubuntu" && var.controller_node["os_release"] == "20.04" ? "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img" : var.controller_node["os_distro"] == "ubuntu" && var.controller_node["os_release"] == "22.04" ? "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img" : var.controller_node["os_distro"] == "centos" && var.controller_node["os_release"] == "8" ? "https://cloud.centos.org/centos/8/x86_64/images/CentOS-8-GenericCloud-8.4.2105-20210603.0.x86_64.qcow2" : var.controller_node["os_distro"] == "centos" && var.controller_node["os_release"] == "9" ? "https://cloud.centos.org/centos/9-stream/x86_64/images/CentOS-Stream-GenericCloud-9-20230327.0.x86_64.qcow2" : ""
  format = "qcow2"
}

resource "libvirt_volume" "controller_os_volume" {
  count          = var.controller_node_count
  name           = "controller-${count.index + 1}_os.qcow2"
  pool           = "default"
  size           = var.controller_node["os_disk_size"]
  base_volume_id = libvirt_volume.cloud_init_volume.id
  format         = "qcow2"
}

resource "libvirt_volume" "compute_os_volume" {
  count          = var.compute_node_count
  name           = "compute-${count.index + 1}_os.qcow2"
  pool           = "default"
  size           = var.compute_node["os_disk_size"]
  base_volume_id = libvirt_volume.cloud_init_volume.id
  format         = "qcow2"
}

resource "libvirt_volume" "compute_first_stor_volume" {
  count  = var.compute_node_count
  name   = "compute-${count.index + 1}_stor_0.qcow2"
  pool   = "default"
  size   = var.compute_node.stor_disk_size
  format = "qcow2"
}