locals {
  workers_ceph+_disks = [
    for pair in setproduct(var.worker_count, var.ceph_disk_count) : {
      worker_id = pair[0]
      disk_id   = pair[1]
    }
  ]
}

resource "libvirt_volume" "cloud_image_based" {
  name   = "${var.os_distro}-${var.os_release}.cloudinit"
  source = "http://download.opensuse.org/repositories/Cloud:/Images:/Leap_42.1/images/openSUSE-Leap-42.1-OpenStack.x86_64.qcow2"
}

resource "libvirt_volume" "master_main_disk" {
  name           = "openstack-master-${count.index}.qcow2"
  base_volume_id = libvirt_volume.cloudinit_disk.id
  count          = var.master_count
}

# volumes to attach to the "workers" domains as main disk
resource "libvirt_volume" "worker_main_disk" {
  name           = "worker-${count.index}.qcow2"
  base_volume_id = libvirt_volume.cloudinit.id
  count          = var.worker_count
}

resource "libvirt_volume" "worker_ceph_disk" {
  for_each = { for o in local. : "${o.file_system_id}:${o.subnet_id}" => o }

  file_system_id  = each.value.file_system_id
  subnet_id       = each.value.subnet_id
  security_groups = var.efs_security_groups
}