resource "aws_s3_bucket" "pet-shop-bucket" {
  bucket        = var.bucket-name
  force_destroy = true
  tags = {
    "Name" = var.bucket-name
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.pet-shop-bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.pet-shop-bucket.id
  rule {
    id     = "expire-old-files"
    status = "Enabled"
    expiration {
      days = 5
    }
  }
}