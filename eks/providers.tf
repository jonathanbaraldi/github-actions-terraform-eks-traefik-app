terraform {
  backend "s3" {
    bucket = "state-tform"
    key    = "state-dev"
    region = "us-east-1"
  }
}

