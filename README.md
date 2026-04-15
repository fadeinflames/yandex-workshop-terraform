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
