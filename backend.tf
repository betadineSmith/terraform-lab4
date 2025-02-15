terraform {
  backend "s3" {
    bucket         = "lab4-terraform-state-backend"
    key            = "lab4/terraform.tfstate"
    region         = "eu-west-3"
    encrypt        = true
    dynamodb_table = "lab4-terraform-state"
  }
}