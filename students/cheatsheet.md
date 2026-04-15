# Terraform Cheatsheet

## Основные команды

| Команда | Что делает |
|---------|-----------|
| `terraform init` | Инициализация — скачивает провайдеры |
| `terraform plan` | Показывает что будет изменено (dry-run) |
| `terraform apply` | Применяет изменения |
| `terraform destroy` | Удаляет все ресурсы |
| `terraform fmt` | Форматирует код |
| `terraform validate` | Проверяет синтаксис |
| `terraform output` | Показывает выходные значения |
| `terraform state list` | Список ресурсов в state |
| `terraform state show <ресурс>` | Детали ресурса |

## Символы в terraform plan

| Символ | Значение |
|--------|----------|
| `+` | Ресурс будет создан |
| `-` | Ресурс будет удален |
| `~` | Ресурс будет изменен на месте |
| `-/+` | Ресурс будет пересоздан (удален и создан заново) |

## Структура HCL

```hcl
# Провайдер — подключение к облаку
provider "yandex" {
  token     = var.yc_token
  folder_id = var.yc_folder_id
}

# Ресурс — то, что создаем
resource "тип_ресурса" "имя" {
  параметр = "значение"
}

# Переменная — входной параметр
variable "имя" {
  type    = string
  default = "значение"
}

# Data source — чтение существующего ресурса
data "тип_ресурса" "имя" {
  параметр = "значение"
}

# Output — выходное значение
output "имя" {
  value = ресурс.имя.атрибут
}
```

## Ресурсы Yandex Cloud

### Сеть
```hcl
resource "yandex_vpc_network" "net" {
  name = "my-network"
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "my-subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.net.id
  v4_cidr_blocks = ["10.0.1.0/24"]
}
```

### Виртуальная машина
```hcl
resource "yandex_compute_instance" "vm" {
  name                      = "my-vm"
  platform_id               = "standard-v3"
  allow_stopping_for_update = true  # иначе apply упадёт при смене RAM/CPU

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8jr9omc57n4c6hev20"
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    nat       = true  # внешний IP
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}
```

### Security Group
```hcl
resource "yandex_vpc_security_group" "sg" {
  name       = "my-sg"
  network_id = yandex_vpc_network.net.id

  ingress {
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
```

### Диск
```hcl
resource "yandex_compute_disk" "disk" {
  name = "my-disk"
  size = 10
  type = "network-hdd"  # или network-ssd
  zone = "ru-central1-a"
}
```

## Ссылки между ресурсами

```
yandex_vpc_network.net.id          — ID сети
yandex_vpc_subnet.subnet.id        — ID подсети
yandex_compute_instance.vm.id      — ID машины
yandex_compute_disk.disk.id        — ID диска

# IP-адреса VM
yandex_compute_instance.vm.network_interface.0.ip_address       — внутренний IP
yandex_compute_instance.vm.network_interface.0.nat_ip_address   — внешний IP
```

## Lifecycle

```hcl
resource "..." "..." {
  # ...

  lifecycle {
    create_before_destroy = true  # сначала создать новый, потом удалить старый
    prevent_destroy       = true  # запретить удаление
    ignore_changes        = [labels]  # игнорировать изменения поля
  }
}
```

## Cloud-init (автонастройка VM)

```hcl
metadata = {
  user-data = <<-EOF
    #cloud-config
    package_update: true
    packages:
      - nginx
      - docker.io
    runcmd:
      - systemctl enable nginx
      - systemctl start nginx
  EOF
}
```

## Типовые ошибки

| Ошибка | Причина | Фикс |
|--------|---------|------|
| `Changing the resources ... requires stopping it` | Смена CPU/RAM/platform_id на запущенной VM | `allow_stopping_for_update = true` в ресурсе VM |
| `Image "..." not found` | Устарел хардкод `image_id` | Заменить на `data.yandex_compute_image.ubuntu.id` (блок 3) |
| `Quota limit vpc.networks.count exceeded` | В каталоге уже 2 сети | Удалить ненужную сеть или запросить квоту |
| Нет внешнего IP на VM | Забыли `nat = true` в `network_interface` | Добавить `nat = true` |
| `no such file ~/.ssh/id_rsa.pub` | У вас `id_ed25519` | `ln -s ~/.ssh/id_ed25519.pub ~/.ssh/id_rsa.pub` или поправить путь в `main.tf` |

## Полезные команды YC CLI

```bash
yc config list                        # текущая конфигурация
yc compute instance list              # список VM
yc vpc network list                   # список сетей
yc compute image list --folder-id standard-images  # образы
```
