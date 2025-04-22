#create S3 bucket
resource "aws_s3_bucket" "my-s3-bucket" {
  bucket = var.mybucket

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
#enable ownership control
resource "aws_s3_bucket_ownership_controls" "my-s3-bucket" {
  bucket = aws_s3_bucket.my-s3-bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

#configure public access 
resource "aws_s3_bucket_public_access_block" "my-s3-bucket" {
  bucket = aws_s3_bucket.my-s3-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

#configuring acl
resource "aws_s3_bucket_acl" "my-s3-bucket" {
  depends_on = [
    aws_s3_bucket_ownership_controls.my-s3-bucket,
    aws_s3_bucket_public_access_block.my-s3-bucket,
  ]

  bucket = aws_s3_bucket.my-s3-bucket.id
  acl    = "public-read"
}

#uploading objects to s3 bucket
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.my-s3-bucket.id
  key          = "index.html"
  source       = "./index.html"
  acl          = "public-read"
  content_type = "text/html"
}
resource "aws_s3_object" "style" {
  bucket       = aws_s3_bucket.my-s3-bucket.id
  key          = "styles.css"
  source       = "./styles.css"
  acl          = "public-read"
  content_type = "text/css"
}
resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.my-s3-bucket.id
  key          = "error.html"
  source       = "./error.html"
  acl          = "public-read"
  content_type = "text/html"
}

#configure the website in s3
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.my-s3-bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  /* routing_rule {
    condition {
      key_prefix_equals = "docs/"
    }
    redirect {
      replace_key_prefix_with = "documents/"
    }
  } */

  depends_on = [ aws_s3_bucket_acl.my-s3-bucket ]
}