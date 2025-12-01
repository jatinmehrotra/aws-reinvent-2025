# Import the access entry created by EKS capability
resource "null_resource" "import_access_entry" {
  depends_on = [null_resource.wait_for_argocd]

  provisioner "local-exec" {
    command = <<-EOT
      terraform import -input=false \
        aws_eks_access_entry.capability_role \
        "${local.cluster_name}:${aws_iam_role.eks_capability_role.arn}" || true
    EOT
  }
}

resource "aws_eks_access_entry" "capability_role" {
  cluster_name  = module.eks.cluster_name
  principal_arn = aws_iam_role.eks_capability_role.arn
  type          = "STANDARD"

  lifecycle {
    ignore_changes = [kubernetes_groups]
  }

  depends_on = [null_resource.import_access_entry]
}

# Add ClusterAdmin policy to fix insufficient ArgoCD permissions
resource "aws_eks_access_policy_association" "capability_role_admin" {
  cluster_name  = module.eks.cluster_name
  principal_arn = aws_iam_role.eks_capability_role.arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.capability_role]
}
