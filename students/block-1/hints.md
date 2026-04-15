# Подсказки к Блоку 1

## Подсказка 1: Провайдер
<details>
<summary>Раскрыть</summary>

```hcl
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = var.yc_zone
}
```
</details>

## Подсказка 2: Нет внешнего IP?
<details>
<summary>Раскрыть</summary>

Убедитесь, что в `network_interface` стоит `nat = true`:

```hcl
network_interface {
  subnet_id = yandex_vpc_subnet.ВАША_ПОДСЕТЬ.id
  nat       = true  # <-- это дает внешний IP
}
```
</details>

## Подсказка 3: nginx не запускается?
<details>
<summary>Раскрыть</summary>

Проверьте формат `user-data`. Первая строка ОБЯЗАТЕЛЬНО должна быть `#cloud-config`:

```hcl
user-data = <<-EOF
  #cloud-config
  package_update: true
  packages:
    - nginx
  runcmd:
    - systemctl enable nginx
    - systemctl start nginx
EOF
```

Также nginx может запуститься не сразу — подождите 1-2 минуты после создания VM.
</details>

## Подсказка 4: Ошибка "subnet not found"
<details>
<summary>Раскрыть</summary>

Убедитесь, что зона VM совпадает с зоной подсети. Обе должны быть `ru-central1-a` (или другая, но одинаковая).
</details>

## Подсказка 5: Полная структура VM
<details>
<summary>Раскрыть (это почти решение!)</summary>

```hcl
resource "yandex_compute_instance" "web" {
  name        = "web-server-имя"
  platform_id = "standard-v3"

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
    subnet_id = yandex_vpc_subnet.???.id
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
```
</details>
