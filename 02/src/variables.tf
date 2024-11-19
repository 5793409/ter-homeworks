###cloud vars


variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}



###ssh vars

# variable "vms_ssh_root_key" {
#   type        = string
#   default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFmsrfSRL5iLSx+NcpfpUWB8uGcVxQalOcQcQ/r6yPRg yandex_cloud_nk3409"
#   description = "ssh-keygen -t ed25519"
# }


variable "vm_web_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "yandex_compute_image"
}

variable "vm_web_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "yandex_compute_instance name"
}

variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "yandex_compute_instance platform"
}


#-------------------
variable "vm_resources" {
  type = map(object({
    cores         = number
    memory        = number
    core_fraction = number
    type          = string
    size          = number
  }))
  default = {
    "web" = {
      cores         = 2
      memory        = 1
      core_fraction = 5
      type          = "network-hdd"
      size          = 10
    },
    "db" = {
      cores         = 2
      memory        = 2
      core_fraction = 20
      type          = "network-hdd"
      size          = 10
    }
  }
}


###ssh vars



variable "metadata" {
  type        = object({ serial-port-enable = number, ssh-keys = string })
  default     = { serial-port-enable = 1, ssh-keys = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFmsrfSRL5iLSx+NcpfpUWB8uGcVxQalOcQcQ/r6yPRg yandex_cloud_nk3409" }
  description = "Common ssh params"
}