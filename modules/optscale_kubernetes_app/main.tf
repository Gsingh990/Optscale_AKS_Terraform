resource "kubernetes_namespace" "optscale" {
  metadata {
    name = "optscale"
  }
}

# Kubernetes Secret for Database Credentials
resource "kubernetes_secret" "db_credentials" {
  metadata {
    name      = "optscale-db-credentials"
    namespace = kubernetes_namespace.optscale.metadata[0].name
  }
  data = {
    "db_host"     = var.db_host
    "db_name"     = var.db_name
    "db_user"     = var.db_user
    "db_password" = var.db_password
  }
  type = "Opaque"
}

# Kubernetes Secret for Redis Credentials
resource "kubernetes_secret" "redis_credentials" {
  metadata {
    name      = "optscale-redis-credentials"
    namespace = kubernetes_namespace.optscale.metadata[0].name
  }
  data = {
    "redis_host"     = var.redis_host
    "redis_password" = var.redis_password
  }
  type = "Opaque"
}

# Kubernetes Secret for Storage Account Credentials
resource "kubernetes_secret" "storage_credentials" {
  metadata {
    name      = "optscale-storage-credentials"
    namespace = kubernetes_namespace.optscale.metadata[0].name
  }
  data = {
    "storage_account_name" = var.storage_account_name
    "storage_account_key"  = var.storage_account_key
  }
  type = "Opaque"
}

# RabbitMQ Deployment (simplified)
resource "kubernetes_deployment" "rabbitmq" {
  metadata {
    name      = "rabbitmq"
    namespace = kubernetes_namespace.optscale.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "rabbitmq"
      }
    }
    template {
      metadata {
        labels = {
          app = "rabbitmq"
        }
      }
      spec {
        container {
          name  = "rabbitmq"
          image = "rabbitmq:3-management"
          port {
            container_port = 5672
          }
          env {
            name  = "RABBITMQ_DEFAULT_USER"
            value = "guest"
          }
          env {
            name  = "RABBITMQ_DEFAULT_PASS"
            value = "guest"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "rabbitmq" {
  metadata {
    name      = "rabbitmq"
    namespace = kubernetes_namespace.optscale.metadata[0].name
  }
  spec {
    selector = {
      app = "rabbitmq"
    }
    port {
      port        = 5672
      target_port = 5672
    }
    type = "ClusterIP"
  }
}

# OptScale Backend Deployment (simplified)
resource "kubernetes_deployment" "optscale_backend" {
  metadata {
    name      = "optscale-backend"
    namespace = kubernetes_namespace.optscale.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "optscale-backend"
      }
    }
    template {
      metadata {
        labels = {
          app = "optscale-backend"
        }
      }
      spec {
        container {
          name  = "optscale-backend"
          image = "optscale/optscale:latest" # Placeholder image
          port {
            container_port = 80
          }
          env {
            name  = "DB_HOST"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.db_credentials.metadata[0].name
                key  = "db_host"
              }
            }
          }
          env {
            name  = "DB_NAME"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.db_credentials.metadata[0].name
                key  = "db_name"
              }
            }
          }
          env {
            name  = "DB_USER"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.db_credentials.metadata[0].name
                key  = "db_user"
              }
            }
          }
          env {
            name  = "DB_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.db_credentials.metadata[0].name
                key  = "db_password"
              }
            }
          }
          env {
            name  = "REDIS_HOST"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.redis_credentials.metadata[0].name
                key  = "redis_host"
              }
            }
          }
          env {
            name  = "REDIS_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.redis_credentials.metadata[0].name
                key  = "redis_password"
              }
            }
          }
          env {
            name  = "STORAGE_ACCOUNT_NAME"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.storage_credentials.metadata[0].name
                key  = "storage_account_name"
              }
            }
          }
          env {
            name  = "STORAGE_ACCOUNT_KEY"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.storage_credentials.metadata[0].name
                key  = "storage_account_key"
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "optscale_backend" {
  metadata {
    name      = "optscale-backend"
    namespace = kubernetes_namespace.optscale.metadata[0].name
  }
  spec {
    selector = {
      app = "optscale-backend"
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "ClusterIP"
  }
}

# OptScale Frontend Deployment (simplified)
resource "kubernetes_deployment" "optscale_frontend" {
  metadata {
    name      = "optscale-frontend"
    namespace = kubernetes_namespace.optscale.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "optscale-frontend"
      }
    }
    template {
      metadata {
        labels = {
          app = "optscale-frontend"
        }
      }
      spec {
        container {
          name  = "optscale-frontend"
          image = "optscale/optscale-ui:latest" # Placeholder image
          port {
            container_port = 80
          }
          env {
            name  = "API_URL"
            value = "http://optscale-backend.optscale.svc.cluster.local" # Internal K8s service URL
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "optscale_frontend" {
  metadata {
    name      = "optscale-frontend"
    namespace = kubernetes_namespace.optscale.metadata[0].name
  }
  spec {
    selector = {
      app = "optscale-frontend"
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "LoadBalancer" # Expose frontend externally
  }
}
