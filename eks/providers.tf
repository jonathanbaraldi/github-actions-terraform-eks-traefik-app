terraform {
  backend "s3" {
    bucket = "vf-tfstate"
    key    = "devops-ninja-eks"
    region = "us-east-1"
  }
}

