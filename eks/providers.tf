terraform {
  backend "s3" {
    bucket = "github-actions-terraform-eks-traefik-app-fernandomuller"
    key    = "devops-ninja-eks"
    region = "us-east-2"
  }
}

