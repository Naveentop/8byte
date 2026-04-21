provider "aws" {
    region = "ap-south-1"
}

terraform {
  backend "s3" {
    bucket = "byte-tf-bucket"
    key = "Central-state"
    region = "ap-south-1"
    use_lockfile = true
}
}
