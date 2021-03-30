terraform {
  backend "s3" {
    bucket = "terraform-deploy-jonjon"
    key    = "devops-ninja-eks"
    region = "us-east-2"
  }
}

