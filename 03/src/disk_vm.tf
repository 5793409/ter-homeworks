resource "yandex_compute_disk" "disk_1tb" {
  count = 3
  name  = "disk-${count.index + 1}"
  size  = 1
}


resource "yandex_compute_instance" "vmstorage" {
  name        = "storage1"
  hostname    = "storage1"
  platform_id = var.platform_name1
  resources {
    cores         = 2
    memory        = 1
    core_fraction = 5
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }

  dynamic "secondary_disk" {

    for_each = { for stor in yandex_compute_disk.disk_1tb[*] : stor.name => stor }
    content {

      disk_id = secondary_disk.value.id
    }
  }


  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_develop.id
    nat       = true
    security_group_ids = [
      yandex_vpc_security_group.example.id,
    ]
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${local.vms_ssh_root_key}"
  }

}