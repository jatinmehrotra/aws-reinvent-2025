resource "aws_eks_access_entry" "devops_agent" {
  cluster_name  = module.eks.cluster_name
  principal_arn = var.devops_agent_role_arn
}

resource "aws_eks_access_policy_association" "devops_agent" {
  cluster_name  = module.eks.cluster_name
  principal_arn = var.devops_agent_role_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminViewPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.devops_agent]
}
