terraform {
  backend "s3" {
    bucket = "terraform-romao-eks-teste"
    key    = "romao-devops-eks"
    region = "sa-east-1"
  }
}

