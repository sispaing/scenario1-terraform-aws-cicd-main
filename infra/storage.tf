# --- S3 Bucket for Website Content ---
resource "aws_s3_bucket" "web_content" {
  bucket = "${var.project_name}-web-content"
  tags   = { Name = "${var.project_name}-web-bucket" }
}

resource "aws_s3_bucket_public_access_block" "web_content" {
  bucket                  = aws_s3_bucket.web_content.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
