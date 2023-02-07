terraform {
  backend "s3" {
    bucket = "tfstore97"
    key    = "files/"
    region = "ap-south-1"
  }
}