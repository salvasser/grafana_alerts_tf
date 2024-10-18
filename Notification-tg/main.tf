resource "grafana_contact_point" "telegram" {
  name = var.contact_point_name

  telegram {
    chat_id = var.tg_chat_id
    token   = var.tg_bot_token
    message = var.message_template
  }
}

resource "grafana_notification_policy" "tg_notification" {
  contact_point   = grafana_contact_point.telegram.name
  group_by        = ["grafana_folder", "alertname"]
  group_wait      = var.group_wait
  group_interval  = var.group_interval
  repeat_interval = var.repeat_interval
  depends_on      = [grafana_contact_point.telegram]
}
