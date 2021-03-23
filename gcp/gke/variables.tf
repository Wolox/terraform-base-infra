variable "project" {
  type = string
}

variable "credentials" {
  type = string
}

variable "cluster_name" {
  type    = string
  default = "cluster"
}

variable "location" {
  type = string
}

variable "zone" {
  type = string
}
variable "nodes_size" {
  type = string
}

variable "autoscale_min_nodes" {
  type    = number
  default = 1
}

variable "autoscale_max_nodes" {
  type    = number
  default = 10
}

variable "subnet_cidr" {
  type    = string
  default = "10.20.0.0/28"
}

variable "subnet_cluster_cidr" {
  type    = string
  default = "10.21.0.0/21"
}

variable "subnet_services_cidr" {
  type    = string
  default = "10.22.0.0/21"
}

# lun a vie de 3 a 7 am
variable "daily_maintenance_window_start_time" {
  description = "Fecha y hora en la que inicia la ventana de mantenimiento."
  default     = "2020-12-01T06:00:00Z"
}

variable "daily_maintenance_window_end_time" {
  description = "Fecha y hora en la que finaliza la ventana de mantenimiento."
  default     = "2020-12-01T10:00:00Z"
}

variable "daily_maintenance_recurrence" {
  default = "FREQ=WEEKLY;BYDAY=MO,TU,WE,TH,FR"
}
