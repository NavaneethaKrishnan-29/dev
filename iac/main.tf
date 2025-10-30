terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_deployment" "dev_app" {
  metadata {
    name = "dev-deploy"
    labels = {
      app = "dev-app"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "dev-app"
      }
    }
    template {
      metadata {
        labels = {
          app = "dev-app"
        }
      }
      spec {
        container {
          image = "naveen4251/dev:latest"
          name  = "dev-container"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "dev_service" {
  metadata {
    name = "dev-service"
  }

  spec {
    selector = {
      app = "dev-app"
    }
    port {
      port        = 80
      target_port = 80
      node_port   = 30008
    }
    type = "NodePort"
  }
}
