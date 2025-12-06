# EKS DevOps Agent

## Setup

1. **Create DevOps Agent first** - You need to create the DevOps agent in AWS to get the IAM role ARN

2. Create `terraform.tfvars` file:
   ```
   devops_agent_role_arn = "<replace with your agent space IAM role arn>"
   ```

3. Replace with your actual IAM role ARN (format: `arn:aws:iam::<account-id>:role/service-role/DevOpsAgentRole-AgentSpace-<id>`)

## Deploy

**Note:** Run `terraform apply` only after creating the DevOps agent in AWS, otherwise you won't have the ARN.

```bash
terraform init
terraform apply
```

## Destroy

```bash
terraform destroy
```
