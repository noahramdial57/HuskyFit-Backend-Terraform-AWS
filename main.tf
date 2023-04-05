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

# SageMaker Notebook Instance 
resource "aws_sagemaker_notebook_instance" "ni" {
  name          = "my-notebook-instance"
  role_arn      = aws_iam_role.notebook_instance_role.arn
  instance_type = "ml.t3.medium"
}

# IAM Role for Notebook Instance
resource "aws_iam_role" "notebook_instance_role" {
  name = "sagemaker-notebook-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "sagemaker.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Policy for Notebook Instance Role
resource "aws_iam_policy" "notebook_instance_policy" {
  name = "sagemaker-notebook-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "sagemaker:*"
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = "s3:*"
        Resource = "*"
      }
    ]
  })
}

# Attach Policy to Notebook Instance Role
resource "aws_iam_role_policy_attachment" "notebook_instance_policy_attachment" {
  policy_arn = aws_iam_policy.notebook_instance_policy.arn
  role       = aws_iam_role.notebook_instance_role.name
}