terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1" # Mumbai
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-unique-demo-bucket-123456"

  tags = {
    Name        = "Demo Bucket"
    Environment = "Dev"
  }
}
