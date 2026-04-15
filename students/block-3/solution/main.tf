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

# Data source — актуальный образ Ubuntu
data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
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

# Security Group
resource "yandex_vpc_security_group" "web_sg" {
  name       = "web-security-group"
  network_id = yandex_vpc_network.workshop.id

  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
    description    = "SSH"
  }

  ingress {
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
    description    = "HTTP"
  }

  ingress {
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
    description    = "HTTPS"
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    description    = "All outbound"
  }
}

# Дополнительный диск
resource "yandex_compute_disk" "data" {
  name = "data-disk-student"
  size = 5
  type = "network-hdd"
  zone = var.yc_zone

  labels = {
    environment = "workshop"
  }
}

# Виртуальная машина — финальная версия
resource "yandex_compute_instance" "web" {
  name                      = "web-server-student"
  platform_id               = "standard-v3"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id # data source!
      size     = 10
    }
  }

  secondary_disk {
    disk_id     = yandex_compute_disk.data.id
    auto_delete = true
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.workshop.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.web_sg.id]
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

  labels = {
    environment = "workshop"
    owner       = "student"
    task        = "block-3"
  }

  lifecycle {
    create_before_destroy = true
  }
}
