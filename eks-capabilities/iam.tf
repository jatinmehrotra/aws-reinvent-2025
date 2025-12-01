resource "aws_iam_role" "eks_capability_role" {
  name = "eks-capability-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "capabilities.eks.amazonaws.com"
        }
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_full_access" {
  role       = aws_iam_role.eks_capability_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
