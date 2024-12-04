data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2004-lts"
}
resource "yandex_compute_instance" "platform" {
  depends_on = [
    yandex_compute_instance.db-vms

  ]
  count = 2

  name        = "web-${count.index + 1}"
  hostname    = "web-${count.index + 1}"
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