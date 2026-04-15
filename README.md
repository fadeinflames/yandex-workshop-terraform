# Workshop: Terraform + Yandex Cloud

Воркшоп по управлению инфраструктурой в Yandex Cloud с помощью Terraform.

**Длительность:** ~1.5 часа
**Уровень:** начинающий
**Формат:** разбор готовых файлов + практические задания (студенты дополняют готовый код)

## Структура репозитория

```
├── students/                  # Материалы для студентов (публичная часть)
│   ├── README.md             # Руководство студента
│   ├── cheatsheet.md         # Шпаргалка по Terraform
│   ├── block-1/              # Задание 1: Создание VM + nginx
│   ├── block-2/              # Задание 2: Изменение инфраструктуры
│   └── block-3/              # Задание 3: Outputs, Data Sources, Lifecycle
│
├── instructor/                # Материалы ведущего (приватная часть)
│   ├── scenario.md           # Полный сценарий с таймингами
│   └── demo/                 # Terraform-файлы для демонстрации
│       ├── block-1/          # Демо: базовая VM
│       ├── block-2/          # Демо: изменения + диск
│       └── block-3/          # Демо: outputs + data sources
│
└── presentation/              # Презентация
    └── slides.md             # Слайды в Markdown
```

## Блоки воркшопа

| # | Тема | Демо | Задание |
|---|------|------|---------|
| 0 | Вступление, IaC, Terraform | 10 мин | — |
| 1 | Создание VM | Provider, сеть, VM | VM + nginx (auto-install) |
| 2 | Изменение инфраструктуры | Ресурсы, labels, диск | + RAM, + диск, + Security Group |
| 3 | Outputs, Data Sources | Outputs, data, lifecycle | Финальная сборка |
| 4 | Итоги, уборка | terraform destroy | — |

## Требования

### Для студентов
- Аккаунт Yandex Cloud с активным каталогом
- Установлен [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.0
- Установлен [YC CLI](https://yandex.cloud/ru/docs/cli/quickstart)
- SSH-ключ (`~/.ssh/id_rsa.pub`)
- OAuth-токен или IAM-токен

### Для ведущего
- Все то же + отдельный каталог YC для демо (квота по умолчанию — 2 VPC-сети, одна занята `default`)
- Ознакомиться с `instructor/scenario.md`

## Быстрый старт для ведущего

```bash
# 1. Подготовить tfvars в instructor/demo/block-1/
cp instructor/demo/block-1/terraform.tfvars.example instructor/demo/block-1/terraform.tfvars
# заполнить yc_token / yc_cloud_id / yc_folder_id (yc config list)

# 2. Инициализировать (один раз)
cd instructor/demo/block-1 && terraform init

# 3. Гонять блоки — state, tfvars и .terraform/ разделены симлинками
#    из block-1 в block-2 и block-3, так что можно работать из любой папки
cd instructor/demo/block-1 && terraform apply   # block 1
cd ../block-2              && terraform apply   # block 2 (in-place)
cd ../block-3              && terraform apply   # block 3 (data source + outputs)
terraform destroy                                # из любой папки
```

Если у тебя SSH-ключ `id_ed25519`, сделай разовый симлинк (все демо-файлы ожидают `id_rsa.pub`):
```bash
ln -s ~/.ssh/id_ed25519.pub ~/.ssh/id_rsa.pub
```
