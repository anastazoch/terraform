data "template_file" "controller_cloud_init_config" {
  count    = var.controller_node_count
  template = var.controller_node["os_distro"] == "ubuntu" && var.controller_node["os_release"] == "20.04" ? file("${path.module}/cloud_init_ubuntu_20.04.cfg") : var.controller_node["os_distro"] == "ubuntu" && var.controller_node["os_release"] == "22.04" ? file("${path.module}/cloud_init_ubuntu_22.04.cfg") : var.controller_node["os_distro"] == "centos" && var.controller_node["os_release"] == "8" ? file("${path.module}/cloud_init_centos_8.cfg") : var.controller_node["os_distro"] == "centos" && var.controller_node["os_release"] == "9" ? file("${path.module}/cloud_init_centos_9.cfg") : ""

  vars = {
    hostname = "${format("%s%02s.%s", local.controller_name_prefix, count.index + 1, var.domain)}"
  }
}

data "template_file" "compute_cloud_init_config" {
  count    = var.compute_node_count
  template = var.compute_node["os_distro"] == "ubuntu" && var.compute_node["os_release"] == "20.04" ? file("${path.module}/cloud_init_ubuntu_20.04.cfg") : var.compute_node["os_distro"] == "ubuntu" && var.compute_node["os_release"] == "22.04" ? file("${path.module}/cloud_init_ubuntu_22.04.cfg") : var.compute_node["os_distro"] == "centos" && var.compute_node["os_release"] == "8" ? file("${path.module}/cloud_init_centos_8.cfg") : var.compute_node["os_distro"] == "centos" && var.compute_node["os_release"] == "9" ? file("${path.module}/cloud_init_centos_9.cfg") : ""

  vars = {
    hostname = "${format("%s%02s.%s", local.compute_name_prefix, count.index + 1, var.domain)}"
  }
}

data "template_file" "controller_network_config" {
  count    = var.controller_node_count
  template = var.controller_node["os_distro"] == "ubuntu" ? file("${path.module}/network_ubuntu.cfg") : var.controller_node["os_distro"] == "centos" ? file("${path.module}/network_centos.cfg") : ""

  vars = {
    domain        = "${var.domain}"
    mgmt_ip       = "${cidrhost(var.networks["management"]["subnet"], var.networks["management"]["ip_offset_controller"] + count.index + 1)}"
    mgmt_netmask  = "${split("/", var.networks["management"]["subnet"])[1]}"
    mgmt_gw       = "${var.networks["management"]["gateway"]}"
    mgmt_ns       = "${join(",", var.networks["management"]["nameservers"])}"
    stor_ip       = "${cidrhost(var.networks["storage"]["subnet"], var.networks["storage"]["ip_offset_controller"] + count.index + 1)}"
    stor_netmask  = "${split("/", var.networks["storage"]["subnet"])[1]}"
    vxlan_ip      = "${cidrhost(var.networks["vxlan"]["subnet"], var.networks["vxlan"]["ip_offset_controller"] + count.index + 1)}"
    vxlan_netmask = "${split("/", var.networks["vxlan"]["subnet"])[1]}"
  }
}

data "template_file" "compute_network_config" {
  count    = var.compute_node_count
  template = var.compute_node["os_distro"] == "ubuntu" ? file("${path.module}/network_ubuntu.cfg") : var.compute_node["os_distro"] == "centos" ? file("${path.module}/network_centos.cfg") : ""

  vars = {
    domain        = "${var.domain}"
    mgmt_ip       = "${cidrhost(var.networks["management"]["subnet"], var.networks["management"]["ip_offset_compute"] + count.index + 1)}"
    mgmt_netmask  = "${split("/", var.networks["management"]["subnet"])[1]}"
    mgmt_gw       = "${var.networks["management"]["gateway"]}"
    mgmt_ns       = "${join(",", var.networks["management"]["nameservers"])}"
    stor_ip       = "${cidrhost(var.networks["storage"]["subnet"], var.networks["storage"]["ip_offset_compute"] + count.index + 1)}"
    stor_netmask  = "${split("/", var.networks["storage"]["subnet"])[1]}"
    vxlan_ip      = "${cidrhost(var.networks["vxlan"]["subnet"], var.networks["vxlan"]["ip_offset_compute"] + count.index + 1)}"
    vxlan_netmask = "${split("/", var.networks["vxlan"]["subnet"])[1]}"
  }
}

resource "libvirt_cloudinit_disk" "controller_cloudinit_iso" {
  count          = var.controller_node_count
  name           = "${format("%s%02s_cloud_init.iso", local.controller_name_prefix, count.index + 1)}"
  user_data      = element(data.template_file.controller_cloud_init_config.*.rendered, count.index)
  network_config = element(data.template_file.controller_network_config.*.rendered, count.index)
}

resource "libvirt_cloudinit_disk" "compute_cloudinit_iso" {
  count          = var.compute_node_count
  name           = "${format("%s%02s_cloud_init.iso", local.compute_name_prefix, count.index + 1)}"
  user_data      = element(data.template_file.compute_cloud_init_config.*.rendered, count.index)
  network_config = element(data.template_file.compute_network_config.*.rendered, count.index)
}

resource "libvirt_volume" "controller_cloud_init_volume" {
  name   = "controller_cloud_init_volume"
  pool   = "default"
  source = var.controller_node["os_distro"] == "ubuntu" && var.controller_node["os_release"] == "20.04" ? "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img" : var.controller_node["os_distro"] == "ubuntu" && var.controller_node["os_release"] == "22.04" ? "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img" : var.controller_node["os_distro"] == "centos" && var.controller_node["os_release"] == "8" ? "https://cloud.centos.org/centos/8/x86_64/images/CentOS-8-GenericCloud-8.4.2105-20210603.0.x86_64.qcow2" : var.controller_node["os_distro"] == "centos" && var.controller_node["os_release"] == "9" ? "https://cloud.centos.org/centos/9-stream/x86_64/images/CentOS-Stream-GenericCloud-9-20230327.0.x86_64.qcow2" : ""
  format = "qcow2"
}

resource "libvirt_volume" "compute_cloud_init_volume" {
  name   = "compute_loud_init_volume"
  pool   = "default"
  source = var.compute_node["os_distro"] == "ubuntu" && var.compute_node["os_release"] == "20.04" ? "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img" : var.compute_node["os_distro"] == "ubuntu" && var.compute_node["os_release"] == "22.04" ? "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img" : var.compute_node["os_distro"] == "centos" && var.compute_node["os_release"] == "8" ? "https://cloud.centos.org/centos/8/x86_64/images/CentOS-8-GenericCloud-8.4.2105-20210603.0.x86_64.qcow2" : var.compute_node["os_distro"] == "centos" && var.compute_node["os_release"] == "9" ? "https://cloud.centos.org/centos/9-stream/x86_64/images/CentOS-Stream-GenericCloud-9-20230327.0.x86_64.qcow2" : ""
  format = "qcow2"
}

resource "libvirt_volume" "controller_os_volume" {
  count          = var.controller_node_count
  name           = "${format("%s%02s_os.qcow2", local.controller_name_prefix, count.index + 1)}"
  pool           = "default"
  size           = var.controller_node["os_disk_size"]
  base_volume_id = libvirt_volume.controller_cloud_init_volume.id
  format         = "qcow2"
}

resource "libvirt_volume" "compute_os_volume" {
  count          = var.compute_node_count
  name           = "${format("%s%02s_os.qcow2", local.compute_name_prefix, count.index + 1)}"
  pool           = "default"
  size           = var.compute_node["os_disk_size"]
  base_volume_id = libvirt_volume.compute_cloud_init_volume.id
  format         = "qcow2"
}

resource "libvirt_volume" "compute_first_stor_volume" {
  count  = var.compute_node_count
  name   = "${format("%s%02s_stor_0.qcow2", local.compute_name_prefix, count.index + 1)}"
  pool   = "default"
  size   = var.compute_node.stor_disk_size
  format = "qcow2"
}