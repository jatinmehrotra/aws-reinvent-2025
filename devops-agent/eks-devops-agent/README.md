# EKS DevOps Agent

## Setup

1. Create `terraform.tfvars` file:
   ```
   devops_agent_role_arn = "<replace with your agent space IAM role arn>"
   ```

2. Replace with your actual IAM role ARN (format: `arn:aws:iam::<account-id>:role/service-role/DevOpsAgentRole-AgentSpace-<id>`)

## Deploy

```bash
terraform init
terraform apply
```

## Destroy

```bash
terraform destroy
```
