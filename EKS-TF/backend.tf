terraform {
  backend "s3" {
    bucket         = "chatbot-statefile"
    region         = "us-east-1"
    key            = "EKS/terraform.tfstate"
    dynamodb_table = "chatbot"
    encrypt        = true
  }
  required_version = ">=0.13.0"
  required_providers {
    aws = {
      version = ">= 2.7.0"
      source  = "hashicorp/aws"
    }
  }
}