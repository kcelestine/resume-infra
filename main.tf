terraform {
  cloud {
    organization = "_cloudcte"

    workspaces {
      name = "aws-terraform-github-actions"
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

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_vpc" "main2" {
  cidr_block = "10.1.0.0/16"
}

resource "null_resource" "example" {
  triggers = {
    value = "A example resource that does nothing!"
  }
}
