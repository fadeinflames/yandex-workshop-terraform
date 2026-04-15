# Блок 3: Outputs, Data Sources и жизненный цикл

> **Где работаем:** всё та же директория, что и в блоках 1–2. Редактируете тот же `main.tf`, добавляете `outputs.tf` рядом. State и tfvars переиспользуются — `terraform plan` покажет только то, что изменилось в блоке 3.

## Задание

Улучшите свою инфраструктуру: замените хардкод на data sources, добавьте полезные outputs и изучите lifecycle-правила.

## Что нужно сделать

### 1. Заменить image_id на Data Source

Вместо хардкода `image_id = "fd8jr9omc57n4c6hev20"` используйте data source:

```hcl
data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}
```

И в boot_disk:
```hcl
image_id = data.yandex_compute_image.ubuntu.id
```

**Зачем?** Image ID может устареть (новая версия Ubuntu). Data source всегда вернет актуальный образ.

### 2. Добавить Outputs

Создайте файл `outputs.tf` со следующими выходными значениями:

| Output | Описание | Значение |
|--------|----------|----------|
| `vm_external_ip` | Внешний IP | `...network_interface.0.nat_ip_address` |
| `vm_internal_ip` | Внутренний IP | `...network_interface.0.ip_address` |
| `vm_id` | ID машины | `...id` |
| `ssh_command` | Готовая SSH-команда | `"ssh ubuntu@${...}"` |
| `web_url` | URL веб-сервера | `"http://${...}"` |

### 3. Добавить lifecycle-правило

Добавьте в ресурс VM блок lifecycle:

```hcl
lifecycle {
  create_before_destroy = true
}
```

**Подумайте:** что это означает? Когда это полезно?

### 4. Применить и проверить

```bash
terraform plan
terraform apply
```

После apply Terraform выведет все outputs. Проверьте:

```bash
# Посмотреть все outputs
terraform output

# Посмотреть конкретный (удобно для скриптов)
terraform output -raw vm_external_ip

# Попробовать SSH через output
$(terraform output -raw ssh_command)

# Открыть веб-сервер
curl $(terraform output -raw web_url)
```

## Бонус (если осталось время)

Попробуйте:
1. Выполните `terraform state list` — посмотрите что Terraform отслеживает
2. Выполните `terraform state show yandex_compute_instance.web` — детали ресурса
3. Закомментируйте secondary_disk и запустите `terraform plan` — что покажет?

## Проверка

- [ ] `image_id` берется из data source (нет хардкода)
- [ ] `terraform output` показывает все 5 значений
- [ ] SSH-команда из output работает
- [ ] `curl` на web_url возвращает страницу nginx

## Время: 15 минут

Если застряли — загляните в [hints.md](hints.md).

## Уборка

**После завершения всех заданий удалите ресурсы!**

```bash
terraform destroy
```

Введите `yes` для подтверждения. Проверьте в консоли YC, что ресурсов не осталось.
