# Подсказки к Блоку 2

## Подсказка 0: Ошибка "requires stopping it"
<details>
<summary>Раскрыть</summary>

Если `terraform apply` падает с:

```
Error: Changing the resources, platform_id, ... requires stopping it.
To acknowledge this action, please set allow_stopping_for_update = true
```

Это Yandex защищает вас от неявной перезагрузки VM. Нужно явно разрешить:

```hcl
resource "yandex_compute_instance" "web" {
  name                      = "web-server-..."
  platform_id               = "standard-v3"
  allow_stopping_for_update = true   # <-- добавить
  # ...
}
```

После этого `apply` сам остановит VM, изменит параметры и запустит обратно. Обратите внимание: ephemeral NAT-IP может смениться после стопа.
</details>

## Подсказка 1: Как изменить RAM
<details>
<summary>Раскрыть</summary>

В блоке `resources` вашей VM просто измените значение:

```hcl
resources {
  cores  = 2
  memory = 4  # было 2
}
```
</details>

## Подсказка 2: Как создать дополнительный диск
<details>
<summary>Раскрыть</summary>

Диск — это отдельный ресурс:

```hcl
resource "yandex_compute_disk" "data" {
  name = "data-disk-имя"
  size = 5
  type = "network-hdd"
  zone = var.yc_zone
}
```

Привязка к VM — блок `secondary_disk` внутри `yandex_compute_instance`:

```hcl
secondary_disk {
  disk_id     = yandex_compute_disk.data.id
  auto_delete = true
}
```
</details>

## Подсказка 3: Security Group — структура egress
<details>
<summary>Раскрыть</summary>

Для исходящего трафика без ограничений:

```hcl
egress {
  protocol       = "ANY"
  v4_cidr_blocks = ["0.0.0.0/0"]
}
```

Обратите внимание: для `protocol = "ANY"` не нужно указывать порт.
</details>

## Подсказка 4: Ошибка "security group not attached"
<details>
<summary>Раскрыть</summary>

Не забудьте добавить `security_group_ids` в `network_interface` вашей VM:

```hcl
network_interface {
  subnet_id          = yandex_vpc_subnet.workshop.id
  nat                = true
  security_group_ids = [yandex_vpc_security_group.web_sg.id]
}
```
</details>

## Подсказка 5: Полная Security Group
<details>
<summary>Раскрыть (это почти решение!)</summary>

```hcl
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
```
</details>
