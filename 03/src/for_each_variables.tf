variable "each_vm" {
  type = list(object({
    vm_name       = string
    cpu           = number
    ram           = number
    disk_volume   = number
    core_fraction = number
    # subnet_id     = string # ID подсети, в которой будет создана ВМ
    zone = string # Зона доступности (например, ru-central1-a)
    # image_id    = optional(string, "fd8bqbqh9v7h6f9g20g1") # ID образа ОС
  }))

  # }

  # # Пример значений для переменной
  # variable "each_vm" {
  default = [
    {
      vm_name       = "main"
      cpu           = 2
      ram           = 1
      disk_volume   = 15
      core_fraction = 5
      # subnet_id     = "subnet_develop"
      zone = "ru-central1-a"
      # image_id    = "fd8bqbqh9v7h6f9g20g1"
    },
    {
      vm_name       = "replica"
      cpu           = 2
      ram           = 2
      disk_volume   = 20
      core_fraction = 5
      # subnet_id     = "subnet_develop"
      zone = "ru-central1-a"
      # image_id    = "fd8bqbqh9v7h6f9g20g1"
    }
  ]
}
