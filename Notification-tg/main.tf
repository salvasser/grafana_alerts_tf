resource "grafana_contact_point" "telegram" {
  name = var.contact_point_name

  telegram {
    chat_id = var.tg_chat_id
    token   = var.tg_bot_token
    message = <<EOT
      {{ if .Alerts.Firing -}}
      Firing alerts:
      {{- range .Alerts.Firing }}
      {{ template "firing message template" . }}
      {{ end }}
      {{ end }}

      {{ if .Alerts.Resolved -}}
      Resolved alerts:
      {{- range .Alerts.Resolved }}
      {{ template "resolved message template" . }}
      {{- end }}
      {{- end }}
    EOT
  }
}

resource "grafana_notification_policy" "tg_notification" {
  contact_point   = grafana_contact_point.telegram.name
  group_by        = var.group_by
  group_wait      = var.group_wait
  group_interval  = var.group_interval
  repeat_interval = var.repeat_interval
  depends_on      = [grafana_contact_point.telegram]
}
