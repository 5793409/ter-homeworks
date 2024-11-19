output "test" {

  value = [
    { vm-web = ["instance name ${yandex_compute_instance.platform.name}", "external ip ${yandex_compute_instance.platform.network_interface[0].nat_ip_address}", "fqdn ${yandex_compute_instance.platform.fqdn}"] },
    { vm-db = ["instance name ${yandex_compute_instance.vm_db_platform.name}", "external ip ${yandex_compute_instance.vm_db_platform.network_interface[0].nat_ip_address}", "fqdn ${yandex_compute_instance.vm_db_platform.fqdn}"] }
  ]
}