import {
  to = aws_eks_access_entry.capability_role
  id = "reinvent-2025:arn:aws:iam::825765422255:role/eks-capability-role"
}

resource "aws_eks_access_entry" "capability_role" {
  cluster_name  = module.eks.cluster_name
  principal_arn = aws_iam_role.eks_capability_role.arn
  type          = "STANDARD"

  lifecycle {
    ignore_changes = [kubernetes_groups]
  }

  depends_on = [null_resource.wait_for_argocd]
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
