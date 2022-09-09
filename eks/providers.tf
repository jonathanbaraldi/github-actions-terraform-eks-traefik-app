terraform {
  backend "s3" {
    bucket = "terraform-deploy-jonjon"
    key    = "ninja-eks"
    region = "us-east-2"
  }
}

