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
