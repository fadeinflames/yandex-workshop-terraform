# Terraform + Yandex Cloud: Материалы студента

## Перед началом

### 1. Проверьте, что все установлено

```bash
terraform version   # >= 1.0
yc version          # YC CLI
ls ~/.ssh/id_rsa.pub ~/.ssh/id_ed25519.pub 2>/dev/null   # SSH-ключ существует
```

### 2. Получите ваши данные

```bash
yc config list
```

Вам понадобятся:
- **token** — OAuth-токен (или `yc iam create-token` для IAM-токена)
- **cloud-id** — ID облака
- **folder-id** — ID каталога

### 3. Создайте рабочую директорию

```bash
mkdir terraform-workshop && cd terraform-workshop
```

> **Важно:** все три блока вы выполняете в **одной и той же директории**.
> В каждом следующем блоке вы дополняете и редактируете тот же `main.tf` — не создавайте отдельные папки под block-2 и block-3. Благодаря этому Terraform сохраняет state (`terraform.tfstate`), провайдер (`.terraform/`) и ваши переменные (`terraform.tfvars`) между блоками, и `terraform plan` показывает именно разницу между тем, что уже создано, и новой версией файла.
>
> Папки `students/block-N/solution/` — это эталонные решения для самопроверки, а не шаблоны под копирование целиком в отдельные директории.

### 4. Создайте файл `terraform.tfvars`

```hcl
yc_token     = "ваш_токен"
yc_cloud_id  = "ваш_cloud_id"
yc_folder_id = "ваш_folder_id"
yc_zone      = "ru-central1-a"
```

> **Не коммитьте этот файл!** Он содержит секреты.

### 4a. Если у вас ключ `id_ed25519`

Все файлы воркшопа ожидают `~/.ssh/id_rsa.pub`. Проще всего сделать разовый симлинк:

```bash
ln -s ~/.ssh/id_ed25519.pub ~/.ssh/id_rsa.pub
```

Альтернатива — заменить `id_rsa.pub` на `id_ed25519.pub` в строке `ssh-keys` внутри `main.tf`.

---

## Задания

| Блок | Тема | Ссылка |
|------|------|--------|
| 1 | Создание VM + nginx | [block-1/README.md](block-1/README.md) |
| 2 | Изменение инфраструктуры | [block-2/README.md](block-2/README.md) |
| 3 | Outputs, Data Sources, Lifecycle | [block-3/README.md](block-3/README.md) |

## Шпаргалка

[cheatsheet.md](cheatsheet.md) — команды, синтаксис, примеры ресурсов.

## После воркшопа

**Обязательно удалите все ресурсы:**

```bash
terraform destroy
```

Проверьте в [консоли Yandex Cloud](https://console.yandex.cloud/), что не осталось запущенных ресурсов.
