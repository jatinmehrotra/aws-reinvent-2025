resource "kubectl_manifest" "argocd_application" {
  depends_on = [kubectl_manifest.cluster_register]
  yaml_body  = file("${path.module}/argocd-application.yaml")
}
