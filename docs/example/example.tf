provider "grafana" {
  url  = var.grafana_url
}

#========================================

variable "grafana_url" {
    description = "Grafana instance URL"
    default = "http://127.0.0.1:8090"
}

variable "tg_chat_id" {
    description = "Telegram chat ID"
    default = "-4230702408"
}

variable "tg_bot_token" {
    description = "Telegram bot token"
    default = "7387774233:AAEakVm8I-jwCIgFhs3buYDBEjTX_W9M4WU"
}

#========================================

data "grafana_dashboard" "cpu_and_memory" {
  uid = "nv26fsv5nwi"
}

data "grafana_data_source" "prometheus" {
  name = "prometheus"
}

data "grafana_folder" "resources" {
  title = "Resources"
}

#========================================

module "local_alerts" {
  source = "./modules/alert"

  group_name   = "Local monitoring"
  
  alerts = [
    {
      name         = "High CPU Usage Alert"
      for          = "0s"
      expr         = "sum by (instance) (avg by (mode, instance) (rate(node_cpu_seconds_total{mode!=\"idle\"}[2m])))"
      reducer_type = "last"
      compare      = ">"
      threshold    = 0.01
      summary      = "CPU usage has exceeded 70% for the past 5 minutes."
      description  = "This alert indicates that the CPU usage on the instance has consistently been over 70% for the last 5 minutes. Please investigate possible causes, such as increased load or inefficient processes."
      panel_id     = "1"
      time_range   = 600
    },
    {
      name         = "High Memory Usage Alert"
      for          = "30s"
      expr         = "(node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes"
      reducer_type = "last"
      compare      = ">"
      threshold    = 0.85
      summary      = "Memory usage has exceeded 85% for the past 5 minutes."
      description  = "This alert indicates that the memory usage on the instance has consistently been over 85% for the last 5 minutes. Please investigate possible causes."
      panel_id     = "2"
      time_range   = 600
    }
  ]

  datasource_uid = data.grafana_data_source.prometheus.uid
  dashboard_uid  = data.grafana_dashboard.cpu_and_memory.uid
  folder_uid     = data.grafana_folder.resources.uid
}

module "test_alert" {
  source = "./modules/alert"

  group_name   = "Test"
  
  alerts = [
    {
      name         = "Test"
      for          = "0s"
      expr         = "vector(1)"
      reducer_type = "last"
      compare      = "=="
      threshold    = 2
      summary      = "Test"
      description  = "Test"
      time_range   = 600
    }
  ]

  datasource_uid = data.grafana_data_source.prometheus.uid
  folder_uid     = data.grafana_folder.resources.uid

  labels = {
    "environment" = "test"
    "team"        = "devops"
  }
}

#========================================

module "telegram_notification" {
  source = "./modules/notification"

  contact_point_name = "telegram"
  tg_chat_id         = var.tg_chat_id
  tg_bot_token       = var.tg_bot_token
  
  group_wait      = "30s"
  group_interval  = "1m"
  repeat_interval = "1m"
  group_by        = ["instance", "alertname"]
}

#========================================

module "custom_message_template" {
  source = "./modules/message_template"  
  name = "custom_message_template"
}

#========================================

output "grafana_data_source_uid" {
  value = data.grafana_data_source.prometheus.uid
}

output "grafana_folder_uid" {
  value = data.grafana_folder.resources.uid
}