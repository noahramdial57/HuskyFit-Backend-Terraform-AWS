# Configure the AWS Provider
# access key and secret access key were set in env vars

provider "aws" {
#   version = "~> 2.0"  # this is deprecated
  region  = "us-east-1"
}


resource "aws_s3_bucket" "huskyfit-bucket-test-tf" {
  bucket = "my-tf-test-bucket"


}