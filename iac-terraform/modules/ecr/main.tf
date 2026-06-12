resource "aws_ecr_repository" "ecr" {
  name                 = var.ecr_name
  image_tag_mutability = var.image_mutability
  image_scanning_configuration {
    scan_on_push = true
  }
  dynamic "image_tag_mutability_exclusion_filter" {
    for_each = var.tag_exclusion
    content {
      filter      = image_tag_mutability_exclusion_filter.value
      filter_type = "WILDCARD"
    }

  }
  encryption_configuration {
    encryption_type = var.encrypt_type
  }
  tags = {
    Name = var.ecr_name
  }
}
resource "aws_ecr_lifecycle_policy" "ecr_rules" {
  repository = aws_ecr_repository.ecr.name
  policy = <<EOF
  {
  "rules": [
    {
      "rulePriority": 1,
      "description": "Expire images older than 3 days",
      "selection": {
        "tagStatus": "tagged",
        "countType": "imageCountMoreThan",
        "countNumber": 3
      },
      "action": {
        "type": "expire"
      }
    },
    {
      "rulePriority": 2,
      "description": "Delete images not pulled in 90 days",
      "selection": {
        "tagStatus": "any",
        "countType": "sinceImagePulled",
        "countUnit": "days",
        "countNumber": 90
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
  EOF
}