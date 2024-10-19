resource "grafana_message_template" "message" {
  name     = var.name
  disable_provenance = var.editable
  template = <<EOT
{{ define "firing message template" }}
🔥{{- .Labels.alertname }}
Summary: {{ .Annotations.summary }}
Instance {{ .Labels.instance }}: {{ printf "%.4f" .Values.B }}
{{ end }}

{{ define "resolved message template" }}
✅{{- .Labels.alertname }}
Instance {{ .Labels.instance }}
{{ end }}
EOT
}