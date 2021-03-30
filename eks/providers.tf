terraform {
  backend "s3" {
    bucket = "terraform-deploy-jonjon"
    key    = "eks"
    region = "us-east-2"
  }
}

