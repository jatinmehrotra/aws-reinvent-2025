#!/bin/bash
# Run this script before terraform destroy to delete capabilities

CLUSTER_NAME="reinvent-2025"
REGION="us-east-1"

echo "Deleting ArgoCD capability..."
aws eks delete-capability \
  --region $REGION \
  --cluster-name $CLUSTER_NAME \
  --capability-name my-argocd \
  2>/dev/null || echo "ArgoCD capability already deleted or doesn't exist"

echo "Deleting ACK capability..."
aws eks delete-capability \
  --region $REGION \
  --cluster-name $CLUSTER_NAME \
  --capability-name my-ack \
  2>/dev/null || echo "ACK capability already deleted or doesn't exist"

echo ""
echo "Waiting for capabilities to be fully deleted..."

# Wait for ArgoCD capability to be deleted
while true; do
  STATUS=$(aws eks describe-capability \
    --region $REGION \
    --cluster-name $CLUSTER_NAME \
    --capability-name my-argocd \
    --query 'capability.status' \
    --output text 2>/dev/null)
  
  if [ $? -ne 0 ]; then
    echo "✓ ArgoCD capability deleted"
    break
  fi
  echo "  ArgoCD capability status: $STATUS"
  sleep 5
done

# Wait for ACK capability to be deleted
while true; do
  STATUS=$(aws eks describe-capability \
    --region $REGION \
    --cluster-name $CLUSTER_NAME \
    --capability-name my-ack \
    --query 'capability.status' \
    --output text 2>/dev/null)
  
  if [ $? -ne 0 ]; then
    echo "✓ ACK capability deleted"
    break
  fi
  echo "  ACK capability status: $STATUS"
  sleep 5
done

echo ""
echo "✓ All capabilities deleted successfully!"
echo "You can now run: terraform destroy"
