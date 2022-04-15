terraform {
  //required_version = ">= 0.9.5"
  backend "s3" {
    bucket = "tfstate.lab.refinedev.io"
    key = "lab/terraform.tfstate"
    region = "ap-northeast-2"
    encrypt = true
    dynamodb_table = "TerraformStateLock"
    acl = "bucket-owner-full-control"
  }
}