resource "aws_iam_policy" "app-policy" {
  name        = var.policy-name
  description = "Create policy for mandatory resources for pet shop app"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "SecretPetshopGetandDescribe"
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = "arn:aws:secretsmanager:us-east-1:*:secret:petshop-db-secret-pem-*"
      },
      {
        Sid = "PetShopDecryptKey"
        Effect = "Allow"
        Action = [
          "kms:Decrypt"
        ]
        Resource = "arn:aws:kms:us-east-1:*:key/a1b24377-128c-47d6-a090-eb380b95fde6"
      },
      {
        Sid = "PetShopBucketReadAccess"
        Effect = "Allow"
        Action = [
          "s3:Get*",
          "s3:List*"
        ]
        Resource = [
            "arn:aws:s3:::pet-shop-app-store-images",
            "arn:aws:s3:::pet-shop-app-store-images/*"
        ]
      }
    ]
  })
  tags = {
    "Name" = var.policy-name
  }
}