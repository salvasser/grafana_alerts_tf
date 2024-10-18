resource "grafana_message_template" "message" {
  name     = var.name
  template = var.template_content
}