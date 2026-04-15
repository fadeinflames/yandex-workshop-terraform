# Подсказки к Блоку 3

## Подсказка 1: Data source — как использовать
<details>
<summary>Раскрыть</summary>

Data source объявляется так:
```hcl
data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}
```

Используется так (в boot_disk > initialize_params):
```hcl
image_id = data.yandex_compute_image.ubuntu.id
```

Обратите внимание: `data.` — обязательный префикс.
</details>

## Подсказка 2: Output — синтаксис
<details>
<summary>Раскрыть</summary>

```hcl
output "имя_output" {
  description = "Описание"
  value       = значение
}
```

Пример для SSH-команды:
```hcl
output "ssh_command" {
  description = "Команда для SSH-подключения"
  value       = "ssh ubuntu@${yandex_compute_instance.web.network_interface.0.nat_ip_address}"
}
```
</details>

## Подсказка 3: Как получить IP из ресурса
<details>
<summary>Раскрыть</summary>

Внешний IP:
```
yandex_compute_instance.ВАША_VM.network_interface.0.nat_ip_address
```

Внутренний IP:
```
yandex_compute_instance.ВАША_VM.network_interface.0.ip_address
```

ID машины:
```
yandex_compute_instance.ВАША_VM.id
```
</details>

## Подсказка 4: create_before_destroy — что это
<details>
<summary>Раскрыть</summary>

По умолчанию Terraform при пересоздании ресурса: сначала удаляет старый, потом создает новый. Это значит простой.

`create_before_destroy = true` меняет порядок: сначала создается новый ресурс, потом удаляется старый. Полезно для zero-downtime.

```hcl
lifecycle {
  create_before_destroy = true
}
```
</details>

## Подсказка 5: Полный outputs.tf
<details>
<summary>Раскрыть (это решение!)</summary>

```hcl
output "vm_external_ip" {
  description = "Внешний IP-адрес VM"
  value       = yandex_compute_instance.web.network_interface.0.nat_ip_address
}

output "vm_internal_ip" {
  description = "Внутренний IP-адрес VM"
  value       = yandex_compute_instance.web.network_interface.0.ip_address
}

output "vm_id" {
  description = "ID виртуальной машины"
  value       = yandex_compute_instance.web.id
}

output "ssh_command" {
  description = "Команда для SSH-подключения"
  value       = "ssh ubuntu@${yandex_compute_instance.web.network_interface.0.nat_ip_address}"
}

output "web_url" {
  description = "URL веб-сервера"
  value       = "http://${yandex_compute_instance.web.network_interface.0.nat_ip_address}"
}
```
</details>
