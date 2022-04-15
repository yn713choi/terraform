// terrafrom state 파일용 lock 테이블
resource "aws_dynamodb_table" "terraform_state_lock" {
  name = "TerraformStateLock"
  read_capacity = 5
  write_capacity = 5
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

// 로그 저장용 버킷
resource "aws_s3_bucket" "tflogs" {
  bucket = "tflogs.lab.refinedev.io"
}

resource "aws_s3_bucket_acl" "tflogs_acl" {
    bucket = aws_s3_bucket.tflogs.id
    acl    = "log-delivery-write"
}

// Terraform state 저장용 S3 버킷
resource "aws_s3_bucket" "tfstate" {
  bucket = "tfstate.lab.refinedev.io"
  //tags {
  //  Name = "terraform state"
  //}
  //logging {
  //  target_bucket = "${aws_s3_bucket.tflogs.id}"
  //  target_prefix = "log/"
  //}
  //lifecycle {
  //  prevent_destroy = true
  //}
}

resource "aws_s3_bucket_acl" "tfstate_acl" {
    bucket = aws_s3_bucket.tfstate.id
    acl    = "private"
}

resource "aws_s3_bucket_versioning" "tfstate_versioning" {
  bucket = aws_s3_bucket.tfstate.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_logging" "tfstate_logging" {
  bucket = aws_s3_bucket.tfstate.id

  target_bucket = aws_s3_bucket.tflogs.id
  target_prefix = "log/"
}