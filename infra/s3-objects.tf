# Upload web files to S3
resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.web_content.id
  key          = "index.html"
  source       = "web-content/index.html"
  content_type = "text/html"
  etag         = filemd5("web-content/index.html")

  depends_on = [aws_s3_bucket.web_content]
}

resource "aws_s3_object" "style_css" {
  bucket       = aws_s3_bucket.web_content.id
  key          = "style.css"
  source       = "web-content/style.css"
  content_type = "text/css"
  etag         = filemd5("web-content/style.css")

  depends_on = [aws_s3_bucket.web_content]
}

resource "aws_s3_object" "script_js" {
  bucket       = aws_s3_bucket.web_content.id
  key          = "script.js"
  source       = "web-content/script.js"
  content_type = "application/javascript"
  etag         = filemd5("web-content/script.js")

  depends_on = [aws_s3_bucket.web_content]
}