# EKS Capabilities Demo

Deploy ACK and ArgoCD capabilities on Amazon EKS using Terraform.

## Prerequisites

- AWS CLI configured = aws-cli/2.32.7 Python/3.13.9 Darwin/25.1.0 source/arm64
- Terraform >= 1.0
- kubectl

## Configuration

Update `terraform.tfvars`:

```hcl
idc_username = "your-idc-username"
```

## Deploy

```bash
terraform init
terraform apply
```

## Destroy

**Important**: Delete capabilities before destroying the cluster.

```bash
./cleanup-capabilities.sh
terraform destroy
```