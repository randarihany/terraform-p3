terraform {
  backend "s3" {
    bucket         = "terraform-bucket"  # Bucket name as a string
    key            = "dev/terraform.tfstate"  # Path to the state file
    region         = "us-east-1"  # Region as a string
    encrypt        = true  # Enable server-side encryption
    dynamodb_table = "terraform-lock-table"  # Optional: Add DynamoDB table for state locking
  }
}