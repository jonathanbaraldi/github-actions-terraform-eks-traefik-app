terraform {
  backend "s3" {
    bucket = "terraform-deploy-jonjon"
    key    = "devops-eks"
    region = "us-east-2"
  }
}

