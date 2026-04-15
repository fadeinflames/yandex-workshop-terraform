terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 1.0"
}

provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = var.yc_zone
}

# Сеть
resource "yandex_vpc_network" "workshop" {
  name = "workshop-network"
}

# Подсеть
resource "yandex_vpc_subnet" "workshop" {
  name           = "workshop-subnet"
  zone           = var.yc_zone
  network_id     = yandex_vpc_network.workshop.id
  v4_cidr_blocks = ["10.0.1.0/24"]
}

# Виртуальная машина с nginx
resource "yandex_compute_instance" "web" {
  name        = "web-server-student"
  platform_id = "standard-v3"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8jr9omc57n4c6hev20" # Ubuntu 22.04 LTS
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.workshop.id
    nat       = true
  }

  metadata = {
    ssh-keys  = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    user-data = <<-EOF
      #cloud-config
      package_update: true
      packages:
        - nginx
      runcmd:
        - systemctl enable nginx
        - systemctl start nginx
    EOF
  }
}
