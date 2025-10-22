resource "aws_s3_bucket" "state_bucket" {
  bucket = "solucione-state-bucket"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "versioning_bucket" {
  bucket = aws_s3_bucket.state_bucket.bucket

  versioning_configuration {
    status = "Enabled"
  }

  depends_on = [aws_s3_bucket.state_bucket]
}

resource "aws_s3_bucket" "images_bucket" {
  bucket = "solucione-images-bucket"
}
