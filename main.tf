# Configure the AWS Provider
# access key and secret access key were set in env vars


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.5.0"

    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "my-tf-test-bucket" {
  bucket = "huskyfit-bucket-test-tf" # name has to be unique

}

# Monitor spendings
resource "aws_budgets_budget" "monthly-budge" {
  name              = "HuskyFit-Budget"
  budget_type       = "COST"
  limit_amount      = "10"
  limit_unit        = "USD"
  time_period_start = "2023-04-01_00:00"
  time_unit         = "MONTHLY"
}