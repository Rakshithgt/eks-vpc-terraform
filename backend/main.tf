provider "aws" {
  region  = "us-west-2"
}

resource "aws_s3_bucket" "rakshith" {
  bucket = "demo-terraform-eks-state-bucket"
  
  lifecycle {
    prevent_destroy =  false
  }
}

resource "aws_dynamodb_table" "basic-table" {
  name = "terraform-eks-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key =  "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
