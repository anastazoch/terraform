data "template_file" "cloud_init_config" {
  count    = var.node_count
  template = file("${path.module}/cloud_init.cfg")

  vars = {
    hostname     = "${format("%s%02s.%s", local.node_name_prefix, count.index + 1, var.domain)}"
    use_proxy    = var.use_proxy  
    proxy_scheme = var.proxy["scheme"]
    proxy_ipaddr = var.proxy["ip_addr"]
    proxy_port   = var.proxy["port"]
  }
}

data "template_file" "network_config" {
  count    = var.node_count
  template = file("${path.module}/network.cfg")

  vars = {
    domain        = "${var.domain}"
    mgmt_ip       = "${cidrhost(var.networks["management"]["subnet"], var.networks["management"]["ip_offset"] + count.index + 1)}"
    mgmt_netmask  = "${split("/", var.networks["management"]["subnet"])[1]}"
    mgmt_gw       = "${var.networks["management"]["gateway"]}"
    mgmt_ns       = "${join(",", var.networks["management"]["nameservers"])}"
    stor_ip       = "${cidrhost(var.networks["storage"]["subnet"], var.networks["storage"]["ip_offset"] + count.index + 1)}"
    stor_netmask  = "${split("/", var.networks["storage"]["subnet"])[1]}"
  }
}

resource "libvirt_cloudinit_disk" "cloudinit_iso" {
  count          = var.node_count
  name           = "${format("%s%02s_cloud_init.iso", local.node_name_prefix, count.index + 1)}"
  user_data      = element(data.template_file.cloud_init_config.*.rendered, count.index)
  network_config = element(data.template_file.network_config.*.rendered, count.index)
}

resource "libvirt_volume" "cloud_init_volume" {
  name   = "cloud_init_volume"
  pool   = "default"
  source = var.node.os_distro == "ubuntu" && var.node.os_release == "20.04" ? "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img" : ""
  format = "qcow2"
}

resource "libvirt_volume" "os_volume" {
  count          = var.node_count
  name           = "${format("%s%02s_os.qcow2", local.node_name_prefix, count.index + 1)}"
  pool           = "default"
  size           = var.node.os_disk_size
  base_volume_id = libvirt_volume.cloud_init_volume.id
  format         = "qcow2"
}

resource "libvirt_volume" "first_stor_volume" {
  count  = var.node_count
  name   = "${format("%s%02s_stor_0.qcow2", local.node_name_prefix, count.index + 1)}"
  pool   = "default"
  size   = var.node.stor_disk_size
  format = "qcow2"
}

