terraform {
  backend "s3" {
    bucket = "terraform-deploy-cluster-eks"
    key    = "devops-cluster-eks"
    region = "us-east-2"
  }
}

