variable "contact_point_name" {
  type        = string
  description = "Название контактной точки"
  default     = "telegram"
}

variable "tg_chat_id" {
  type        = string
  description = "ID чата для Telegram"
}

variable "tg_bot_token" {
  type        = string
  description = "Токен бота для Telegram"
}

variable "message_template" {
  type        = string
  description = "Шаблон сообщения для уведомлений"
}

variable "group_wait" {
  type        = string
  description = "Time to wait to buffer alerts of the same group before sending a notification"
  default     = "30s"
}

variable "group_interval" {
  type        = string
  description = "Minimum time interval between two notifications for the same group"
  default     = "1m"
}

variable "repeat_interval" {
  type        = string
  description = "Minimum time interval for re-sending a notification if an alert is still firing"
  default     = "1m"
}

variable "group_by" {
  type        = list(string)
  description = "Поля для группировки уведомлений"
  default     = ["grafana_folder", "alertname"]
}
