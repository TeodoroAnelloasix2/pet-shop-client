output "vpc_id" {
  description = "ID of vpc"
  value       = aws_vpc.this-petshop-vpc.id
}
output "vpc_arn" {
  description = "VPC arn"
  value       = aws_vpc.this-petshop-vpc.arn
}

output "public_subnet_id" {
  description = "Public subnet id"
  value       = aws_subnet.public[*].id
}
output "private_subnet_id" {
  description = "Private subnet id"
  value       = aws_subnet.private[*].id
}

output "vpc_cidr" {
  description = "VPC cidr block"
  value       = aws_vpc.this-petshop-vpc.cidr_block
}