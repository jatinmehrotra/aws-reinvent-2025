resource "null_resource" "update_kubeconfig" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --region ${local.region} --name ${local.cluster_name}"
  }

  depends_on = [module.eks]
}

resource "kubernetes_manifest" "nginx_deployment" {
  manifest = {
    apiVersion = "apps/v1"
    kind       = "Deployment"
    metadata = {
      name      = "nginx"
      namespace = "default"
    }
    spec = {
      replicas = 2
      selector = {
        matchLabels = {
          app = "nginx"
        }
      }
      template = {
        metadata = {
          labels = {
            app = "nginx"
          }
        }
        spec = {
          containers = [{
            name  = "nginx"
            image = "ngin:latest"
            ports = [{
              containerPort = 80
            }]
          }]
        }
      }
    }
  }

  wait {
    fields = {}
  }

  depends_on = [null_resource.update_kubeconfig]
}
