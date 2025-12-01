module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name                   = local.cluster_name
  kubernetes_version     = "1.33"
  endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }
}

resource "null_resource" "eks_capability_ack" {
  depends_on = [module.eks]

  provisioner "local-exec" {
    command = <<-EOT
      aws eks create-capability \
        --region ${local.region} \
        --cluster-name ${local.cluster_name} \
        --capability-name my-ack \
        --type ACK \
        --role-arn ${aws_iam_role.eks_capability_role.arn} \
        --delete-propagation-policy RETAIN \
        --profile jj
    EOT
  }
}

resource "null_resource" "wait_for_ack" {
  depends_on = [null_resource.eks_capability_ack]

  provisioner "local-exec" {
    command = <<-EOT
      while [ "$(aws eks describe-capability \
        --region ${local.region} \
        --cluster-name ${local.cluster_name} \
        --capability-name my-ack \
        --query 'capability.status' \
        --output text \
        --profile jj)" != "ACTIVE" ]; do
        echo "Waiting for ACK capability to become ACTIVE..."
        sleep 10
      done
      echo "ACK capability is ACTIVE"
    EOT
  }
}

resource "null_resource" "eks_capability_argocd" {
  depends_on = [module.eks]

  provisioner "local-exec" {
    command = <<-EOT
      aws eks create-capability \
        --region ${local.region} \
        --cluster-name ${local.cluster_name} \
        --capability-name my-argocd \
        --type ARGOCD \
        --role-arn ${aws_iam_role.eks_capability_role.arn} \
        --delete-propagation-policy RETAIN \
        --configuration '{
          "argoCd": {
            "awsIdc": {
              "idcInstanceArn": "${tolist(data.aws_ssoadmin_instances.main.arns)[0]}",
              "idcRegion": "${local.region}"
            },
            "rbacRoleMappings": [{
              "role": "ADMIN",
              "identities": [{
                "id": "${data.aws_identitystore_user.admin.user_id}",
                "type": "SSO_USER"
              }]
            }]
          }
        }' \
        --profile jj
    EOT
  }
}

resource "null_resource" "wait_for_argocd" {
  depends_on = [null_resource.eks_capability_argocd]

  provisioner "local-exec" {
    command = <<-EOT
      while [ "$(aws eks describe-capability \
        --region ${local.region} \
        --cluster-name ${local.cluster_name} \
        --capability-name my-argocd \
        --query 'capability.status' \
        --output text \
        --profile jj)" != "ACTIVE" ]; do
        echo "Waiting for ArgoCD capability to become ACTIVE..."
        sleep 10
      done
      echo "ArgoCD capability is ACTIVE"
    EOT
  }
}
