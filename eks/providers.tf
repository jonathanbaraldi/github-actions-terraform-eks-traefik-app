terraform {
  backend "s3" {
    bucket = "terraform-deploy-jonjon"
    key    = "devops-eks-dev"
    region = "us-east-1"
  }
}

