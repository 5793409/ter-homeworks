resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}


resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}


resource "yandex_vpc_subnet" "vm_db_develop" {
  name           = var.vm_db_vpc_name
  zone           = var.vm_db_default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.vm_db_default_cidr
}


data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_family
}
resource "yandex_compute_instance" "platform" {
  # name        = var.vm_web_name
  name        = local.vps[0].vm-web
  hostname    = local.vps[0].vm-web
  platform_id = var.vm_web_platform_id
  zone           = var.default_zone
  # resources {
  #   cores         = 2 # количество ядер, зависит от платформы
  #   memory        = 1 # память в GB
  #   core_fraction = 5 # Гарантированная доля vCPU
  # }
  
    resources {
    cores         = var.vm_resources["web"].cores
    memory        = var.vm_resources["web"].memory
    core_fraction = var.vm_resources["web"].core_fraction
  }

  boot_disk {
    initialize_params {
      type = var.vm_resources["web"].type
      size = var.vm_resources["web"].size
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  # metadata = {
  #   serial-port-enable = 1
  #   ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  # }
   metadata = var.metadata

}

# # VM_DB zone_B

data "yandex_compute_image" "vm_db_ubuntu" {
  family = var.vm_db_family
}
resource "yandex_compute_instance" "vm_db_platform" {
  # name        = var.vm_db_name
  name        = local.vps[1].vm-db
  hostname    = local.vps[1].vm-db
  platform_id = var.vm_db_platform_id
  zone           = var.vm_db_default_zone
  # resources {
  #   cores         = 2 # количество ядер, зависит от платформы
  #   memory        = 2 # память в GB
  #   core_fraction = 20 # Гарантированная доля vCPU
  # }
  resources {
    cores         = var.vm_resources["db"].cores
    memory        = var.vm_resources["db"].memory
    core_fraction = var.vm_resources["db"].core_fraction
  }


  boot_disk {
    initialize_params {
      type = var.vm_resources["db"].type
      size = var.vm_resources["db"].size
      image_id = data.yandex_compute_image.vm_db_ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.vm_db_develop.id
    nat       = true
  }

  # metadata = {
  #   serial-port-enable = 1
  #   ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  # }

   metadata = var.metadata

}

