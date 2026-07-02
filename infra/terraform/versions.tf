terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.40"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }

  # Optional: uncomment to store state in S3 instead of locally.
  # backend "s3" {
  #   bucket = "your-tf-state-bucket"
  #   key    = "rdicidr/terraform.tfstate"
  #   region = "us-east-1"
  # }
}
