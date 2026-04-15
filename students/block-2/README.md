# Блок 2: Изменение инфраструктуры

> **Где работаем:** в той же директории, что и в блоке 1. Продолжайте редактировать тот же `main.tf` — state и `terraform.tfvars` уже на месте, `terraform plan` покажет именно дельту изменений.

## Задание

Модифицируйте инфраструктуру из блока 1. Нужно изменить существующие ресурсы и добавить новые.

## Что нужно сделать

### 1. Увеличить ресурсы VM
- RAM: `2 GB` -> `4 GB`
- Добавьте `allow_stopping_for_update = true` в ресурс VM — без этого флага `terraform apply` упадёт с ошибкой «Changing the resources ... requires stopping it». Terraform должен явно получить разрешение остановить VM на время изменения.
- Добавить labels:
  ```hcl
  labels = {
    environment = "workshop"
    owner       = "ваше_имя"
    task        = "block-2"
  }
  ```

### 2. Добавить дополнительный диск
- Имя: `data-disk-<ваше_имя>`
- Размер: 5 GB
- Тип: `network-hdd`
- Привязать к VM как secondary_disk

### 3. Добавить Security Group
Создайте группу безопасности, которая разрешает:
- **Входящий SSH** (порт 22) — с любого адреса
- **Входящий HTTP** (порт 80) — с любого адреса
- **Входящий HTTPS** (порт 443) — с любого адреса
- **Весь исходящий трафик** — без ограничений

Привяжите security group к сетевому интерфейсу VM.

## Порядок действий

1. Внесите изменения в `main.tf`
2. Запустите `terraform plan` — изучите вывод!
3. Обратите внимание на символы:
   - `~` — ресурс будет изменен (update in-place)
   - `+` — ресурс будет создан
   - `-` — ресурс будет удален
   - `-/+` — ресурс будет пересоздан
4. Запустите `terraform apply`

## Справка по Security Group

```hcl
resource "yandex_vpc_security_group" "имя" {
  name       = "..."
  network_id = yandex_vpc_network.???.id

  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  # ... другие правила

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
```

Привязка к VM:
```hcl
network_interface {
  subnet_id          = ...
  nat                = true
  security_group_ids = [yandex_vpc_security_group.???.id]
}
```

## Проверка

```bash
terraform plan    # Должно показать: 1 to add, 1 to change (или похоже)
terraform apply
```

После apply:
- [ ] `terraform plan` показывает "No changes"
- [ ] VM имеет 4 GB RAM (видно в консоли YC)
- [ ] Дополнительный диск привязан к VM
- [ ] Security group создана и привязана к VM

## Время: 20 минут

Если застряли — загляните в [hints.md](hints.md).
