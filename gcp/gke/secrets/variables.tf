variable "namespace" {
  type    = string
  default = "default"
}

variable "secret_name" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "secret_value" {
  type = string
}

# example: cluster_ca_certificate = module.k8s_cluster.cluster_ca_certificate
variable "cluster_ca_certificate" {
  type = string
}

# example:  endpoint               = module.k8s_cluster.endpoint
variable "endpoint" {
  type = string
}
