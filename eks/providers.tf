terraform {
  backend "s3" {
    bucket = "terraform-deploy-cluster-rke"
    key    = "devops-cluster-eks"
    region = "us-east-2"
  }
}

