data "google_client_config" "default" {
}


provider "kubernetes" {
  host                   = "https://${var.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = var.cluster_ca_certificate
}

resource "kubernetes_secret" "secret_value_example" {
  provider = kubernetes

  metadata {
    name = var.secret_name
    namespace = var.namespace
    labels = {
      "sensitive" = "true"
    }
  }
  data = {
    var.secret_key = var.secret_value
  }

}
