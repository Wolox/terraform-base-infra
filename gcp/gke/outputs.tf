output "endpoint" {
  value = google_container_cluster.primary.endpoint
}

output "cluster_ca_certificate" {
  value = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
}

output "ingress_gateway_ip" {
  value = module.static_ip_ingress_gateway.ip_address
}
