resource "kubectl_manifest" "cluster_register" {
  depends_on = [null_resource.wait_for_argocd]
  yaml_body  = file("${path.module}/argocd-cluster-secret.yaml")
}

