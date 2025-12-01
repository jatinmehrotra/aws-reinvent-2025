resource "null_resource" "argocd_add_cluster" {
  depends_on = [null_resource.wait_for_argocd]

  provisioner "local-exec" {
    command = <<-EOT
      argocd cluster add ${module.eks.cluster_arn} \
        --aws-cluster-name ${module.eks.cluster_arn} \
        --name in-cluster \
        --project default
    EOT
  }
}
