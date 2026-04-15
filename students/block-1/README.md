# Блок 1: Создание веб-сервера в Yandex Cloud

## Задание

Создайте виртуальную машину с веб-сервером nginx. После выполнения `terraform apply` по внешнему IP-адресу машины должна открываться стандартная страница nginx.

## Требования

1. **Сеть и подсеть** — создайте VPC-сеть и подсеть с CIDR `10.0.1.0/24`
2. **Виртуальная машина:**
   - Имя: `web-server-<ваше_имя>` (например, `web-server-ivan`)
   - Платформа: `standard-v3`
   - CPU: 2 ядра
   - RAM: 2 GB
   - Диск: 10 GB, Ubuntu 22.04 LTS (image_id: `fd8jr9omc57n4c6hev20`)
   - Внешний IP: должен быть!
   - SSH-ключ: ваш публичный ключ
3. **nginx** должен быть установлен автоматически при создании VM

## Как установить nginx автоматически

Используйте `metadata` с `user-data` — это механизм cloud-init. При первом запуске VM выполнится скрипт:

```hcl
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
```

## Важно

В демо преподавателя VM называется `demo` (`yandex_compute_instance.demo`).
У вас она должна называться `web` (`yandex_compute_instance.web`) — потому что это веб-сервер.

## Структура файлов

Создайте следующие файлы:

```
block-1/
├── main.tf              # Провайдер, сеть, подсеть, VM
├── variables.tf         # Переменные
└── terraform.tfvars     # Ваши значения (НЕ коммитьте!)
```

## Проверка

```bash
# 1. Применить конфигурацию
terraform init
terraform plan
terraform apply

# 2. Проверить что nginx работает (подставьте ваш IP)
curl http://<EXTERNAL_IP>
```

Если видите HTML-страницу с "Welcome to nginx!" — задание выполнено!

## Время: 20 минут

Если застряли — загляните в [hints.md](hints.md).
