# locals {
#   vps1_name = "vps1-${var.env}-${var.default_zone}"
#   vps2_name = "vps2-${var.env}-${var.vm_db_default_zone}"
# }

locals {

  vps = [
    {
      "vm-web" = "netology-${var.vpc_name}-${var.vm_web_platform_id}-${var.default_zone}-web"
    },
    {
      "vm-db" = "netology-${var.vpc_name}-${var.vm_db_platform_id}-${var.vm_db_default_zone}-db"
    },
  ]
}