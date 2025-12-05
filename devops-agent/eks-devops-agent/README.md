# EKS DevOps Agent

## Setup

1. Replace the IAM role ARN in `terraform.tfvars`:
   ```
   devops_agent_role_arn = "arn:aws:iam::<account-id>:role/service-role/DevOpsAgentRole-AgentSpace-<id>"
   ```

## Deploy

```bash
terraform init
terraform apply
```

## Destroy

```bash
terraform destroy
```
