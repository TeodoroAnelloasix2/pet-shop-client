output "pet-shop-app-policy" {
  description = "Pet shop policy arn for mandatory resources"
  value       = aws_iam_policy.app-policy.arn
}