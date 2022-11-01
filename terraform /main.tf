terraform {
  backend "s3" {
    bucket = "prod-engie-assessment"
    key    = "devops-challenge/terraform.tfstate"
    region = "us-east-1"
  }
}