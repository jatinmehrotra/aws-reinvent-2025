resource "null_resource" "argocd_add_cluster" {
  depends_on = [null_resource.wait_for_argocd]

  provisioner "local-exec" {
    command = <<-EOT
      aws eks update-kubeconfig \
        --name ${local.cluster_name} \
        --region ${local.region} \
        --profile jj
      
      kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: ${local.cluster_name}-cluster
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: cluster
stringData:
  name: ${local.cluster_name}
  server: ${module.eks.cluster_arn}
  project: default
EOF
    EOT
  }
}
