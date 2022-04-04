terraform {
  backend "s3" {
    bucket = "terraform-deploy-jr"
    key    = "devops-eks"
    region = "us-east-2"
  }
}

