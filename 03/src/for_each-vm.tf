resource "yandex_compute_instance" "db-vms" {
  for_each = { for idx, vm in var.each_vm : vm.vm_name => vm }

  name        = "db-vms-${each.value.vm_name}"
  hostname    = "db-vms-${each.value.vm_name}"
  platform_id = var.platform_name1
  zone        = each.value.zone

  resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = each.value.core_fraction
  }

  boot_disk {
    initialize_params {
      # image_id = lookup(each.value, "image_id", "fd8bqbqh9v7h6f9g20g1")
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = each.value.disk_volume
    }
  }

  network_interface {
    # subnet_id = each.value.subnet_id
    subnet_id = yandex_vpc_subnet.subnet_develop.id
    nat       = true # Включаем доступ в интернет
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${local.vms_ssh_root_key}"
  }

  scheduling_policy {
    preemptible = true
  }

  labels = {
    environment = "database"
    role        = each.value.vm_name
  }

}


# output "created_vms" {
#   value = {
#     for vm_name, vm in yandex_compute_instance.db_vms :
#     vm_name => {
#       instance_id = vm.id
#       public_ip   = vm.network_interface.0.nat_ip_address
#       private_ip  = vm.network_interface.0.ip_address
#     }
#   }
# }
