#### Create the S3 bucket ####

resource "aws_s3_bucket" "ssm_s3_bucket" {
  bucket              = "${var.s3_bucket}-${data.aws_caller_identity.current.id}-${var.region}"
  object_lock_enabled = true
  force_destroy       = true
  tags = {
    name     = "ssm-logs"
    DataType = "SENSITIVE"
  }
}

resource "aws_s3_bucket" "log_bucket" {
  bucket_prefix = "ssm-log-bucket-"
  force_destroy = true
}


resource "aws_s3_bucket_policy" "allow_write_logs" {
  bucket = aws_s3_bucket.log_bucket.id
  policy = <<EOF
    {
    "Version": "2012-10-17",
    "Id": "S3-Console-Auto-Gen-Policy-1684330819963",
    "Statement": [
        {
            "Sid": "S3PolicyStmt-DO-NOT-MODIFY-1684330819758",
            "Effect": "Allow",
            "Principal": {
                "Service": "logging.s3.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${aws_s3_bucket.log_bucket.bucket}/*"
        }
    ]
}
  EOF
}

#### Configure server side encryption with SSE-S3 ####

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_bucket_encrypt" {
  bucket = aws_s3_bucket.ssm_s3_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

#### Enable versioning on the bucket ####

resource "aws_s3_bucket_versioning" "versioning_s3" {
  bucket = aws_s3_bucket.ssm_s3_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

#### Configure block public access policies on the bucket ####

resource "aws_s3_bucket_public_access_block" "block_public_s3" {
  bucket = aws_s3_bucket.ssm_s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#### Enable server side logging on the S3 bucket ####

resource "aws_s3_bucket_logging" "server_logs" {

  bucket = aws_s3_bucket.ssm_s3_bucket.id

  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "servers-logs/"
}