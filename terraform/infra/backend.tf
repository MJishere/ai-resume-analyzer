terraform {
  backend "s3" {
    bucket         = "ai-resume-analyzer-tf-state"
    key            = "infra/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "ai-resume-analyzer-tf-lock"
    encrypt        = true
  }
}