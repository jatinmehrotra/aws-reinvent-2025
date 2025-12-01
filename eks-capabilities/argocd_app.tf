resource "kubectl_manifest" "argocd_application" {
  depends_on = [null_resource.argocd_add_cluster]
  yaml_body  = file("${path.module}/argocd-application.yaml")
}
