terraform {
  backend "s3" {
    bucket = "state-tform"
    key    = "dev-eks"
    region = "us-east-1"
  }
}

