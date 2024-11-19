### vars for vm_db
variable "vm_db_vpc_name" {
  type        = string
  default     = "vm_db_develop"
  description = "VPC subnet name"
}



variable "vm_db_default_zone" {
  type        = string
  default     = "ru-central1-b"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "vm_db_default_cidr" {
  type        = list(string)
  default     = ["10.0.2.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vm_db_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "yandex_compute_image"
}

variable "vm_db_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "yandex_compute_instance platform"
}

variable "vm_db_name" {
  type        = string
  default     = "netology-develop-platform-db"
  description = "yandex_compute_instance name"
}