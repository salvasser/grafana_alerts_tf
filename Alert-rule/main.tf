resource "grafana_rule_group" "alert_rule" {
  name             = var.group_name
  folder_uid       = var.folder_uid
  interval_seconds = 60
  disable_provenance = var.editable

  dynamic "rule" {
    for_each = var.alerts
    content {
      name      = rule.value.name
      is_paused = false
      condition = "C"
      for       = rule.value.for

      no_data_state  = "NoData"
      exec_err_state = "Alerting"

      # notification_settings {
      #   contact_point = var.contact_point
      # }

      data {
        ref_id = "A"
        relative_time_range {
          from = rule.value.time_range
          to   = 0
        }
        datasource_uid = var.datasource_uid
        model = jsonencode({
          expr          = rule.value.expr,
          intervalMs    = 1000,
          maxDataPoints = 43200,
          refId         = "A"
        })
      }

      data {
        datasource_uid = "__expr__"
        model = jsonencode({
          refId          = "B",
          expression     = "A",
          type           = "reduce",
          reducer        = rule.value.reducer_type
        })
        ref_id = "B"
        relative_time_range {
          from = 0
          to   = 0
        }
      }

      data {
        datasource_uid = "__expr__"
        ref_id = "C"
        relative_time_range {
          from = 0
          to   = 0
        }
        model = jsonencode({
          expression = "$B ${rule.value.compare} ${rule.value.threshold}",
          type       = "math",
          refId      = "C"
        })
      }

      annotations = {
        "summary"     = rule.value.summary
        "description" = rule.value.description
        "__dashboardUid__": rule.value.dashboard_uid,
        "__panelId__": rule.value.panel_id
      }

      labels = var.labels
    }
  }
}