# Create S3 bucket to store frontend files.
resource "aws_s3_bucket" "moodlenet_front_files" {
  provider  = aws.default
  bucket    = "${terraform.workspace}-moodlenet-front-files"
  acl       = "private"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    max_age_seconds = 3600
  }

  tags = {
    Name        = "moodlenet-front-files"
    Environment = terraform.workspace
  }
}
