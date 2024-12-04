resource "local_file" "inventory_cfg" {
  content = templatefile("${path.module}/inventory.tftpl",
    {
      web  = yandex_compute_instance.platform,
      db   = yandex_compute_instance.db-vms,
      stor = length(yandex_compute_instance.vmstorage) > 0 ? [yandex_compute_instance.vmstorage] : []
    }
  )

  filename = "${abspath(path.module)}/hosts.txt"
}


resource "null_resource" "web_hosts_provision" {
  #Ждем создания инстанса
  depends_on = [
    yandex_compute_instance.platform,
    yandex_compute_instance.db-vms,
    yandex_compute_instance.vmstorage,
    local_file.inventory_cfg
  ]


  #Добавление ПРИВАТНОГО ssh ключа в ssh-agent

  provisioner "local-exec" {
    command    = "eval $(ssh-agent) && cat ~/.ssh/yandex_cloud_nk3409_ed25519 | ssh-add -"
    on_failure = continue #Продолжить выполнение terraform pipeline в случае ошибок

  }



  #Костыль!!! Даем ВМ 60 сек на первый запуск. Лучше выполнить это через wait_for port 22 на стороне ansible
  # В случае использования cloud-init может потребоваться еще больше времени
  provisioner "local-exec" {
    command = "sleep 60"
  }

  #Запуск ansible-playbook
  provisioner "local-exec" {
    command     = "export ANSIBLE_HOST_KEY_CHECKING=False; ansible-playbook ${abspath(path.module)}/playbook.yml -i ${abspath(path.module)}/hosts.txt "
    on_failure  = continue #Продолжить выполнение terraform pipeline в случае ошибок
    environment = { ANSIBLE_HOST_KEY_CHECKING = "False" }
    #срабатывание триггера при изменении переменных
  }
  triggers = {
    #всегда т.к. дата и время постоянно изменяются
    always_run = "${timestamp()}"
    # при изменении содержимого playbook файла
    # playbook_src_hash = file("${abspath(path.module)}/playbook.yml")
    # ssh_public_key = local.vms_ssh_root_key } # при изменении переменной
  }

}

