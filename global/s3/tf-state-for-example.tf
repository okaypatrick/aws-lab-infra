
resource "aws_s3_bucket" "tf_state_02" {

  bucket = "ppg9912-tf-state-bucket-02"

  lifecycle {
    prevent_destroy = true

  }

  # Enable versioning
  versioning {
    enabled = true
  }

  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {

        sse_algorithm = "AES256"
      }
    }
  }


}

resource "aws_dynamodb_table" "tf_locks_02" {

  name = "pg-tf-state-locks_02"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}