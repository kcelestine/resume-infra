terraform {
  cloud {
    organization = "_cloudcte"

    workspaces {
      name = "resume-infra"
    }
  }
}

variable "AWS_ACCESS_KEY_ID" {
  type        = string
  description = "AWS_ACCESS_KEY_ID"
}

variable "AWS_SECRET_ACCESS_KEY" {
  type        = string
  description = "AWS_SECRET_ACCESS_KEY"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "resume.khadijahcamille.com"
}
 
resource "aws_s3_bucket_public_access_block" "bucket" {
  bucket = aws_s3_bucket.bucket.id
}
 
resource "aws_s3_bucket_ownership_controls" "bucket" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    object_ownership = "ObjectWriter"
  }
}
 
resource "aws_s3_bucket_website_configuration" "bucket" {
  bucket = aws_s3_bucket.bucket.bucket
  index_document {
    suffix = "index.html"
  }
}
