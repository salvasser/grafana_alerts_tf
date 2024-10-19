variable "group_name" {
  type = string
  default = ""
}

variable "alerts" {
  type = list(object({
    name              = string
    for               = string
    expr              = string
    reducer_type      = string
    compare           = string
    threshold         = number
    summary           = string
    description       = string
    dashboard_uid     = optional(string)
    panel_id          = optional(string)
    time_range        = number
  }))
}

variable "labels" {
  type        = map(string)
  default     = {}
}

variable "datasource_uid" {
  type = string
  default = ""
}

variable "folder_uid" {
  type = string
  default = ""
}

variable "editable" {
  type = bool
  default = false
}

# variable "contact_point" {
#   type = string
#   default = ""
# }