provider "aws" {
  region = "us-east-1" # Change as needed
}

resource "aws_ecr_repository" "hotstar" {
  name = "javaapp"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }
  # ✅ This line tells AWS to delete all images before deleting the repo
  force_delete = true

  tags = {
    Environment = "production"
    Service     = "javaapp"
  }
}


