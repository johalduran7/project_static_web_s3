resource "aws_s3_bucket" "p1_s3_bucket" {
  bucket = var.bucketname

  tags = {
    Name        = "Project 1 static website"
    Environment = "Dev"
  }
}


resource "aws_s3_bucket_ownership_controls" "p1_s3_bucket_ownership" {
  bucket = aws_s3_bucket.p1_s3_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }

}

resource "aws_s3_bucket_public_access_block" "p1_s3_bucket_public_access" {
  bucket = aws_s3_bucket.p1_s3_bucket.id
  #make this false to make the bucket public
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "p1_s3_bucket_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.p1_s3_bucket_ownership,
    aws_s3_bucket_public_access_block.p1_s3_bucket_public_access,
  ]

  bucket = aws_s3_bucket.p1_s3_bucket.id
  acl    = "public-read"

}


resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.p1_s3_bucket.id
  key          = "index.html" #name of the object in s3
  source       = "index.html" # local source
  acl          = "public-read"
  content_type = "text/html"

  depends_on = [
    aws_s3_bucket.p1_s3_bucket,
    aws_s3_bucket_ownership_controls.p1_s3_bucket_ownership,
    aws_s3_bucket_public_access_block.p1_s3_bucket_public_access
  ]

}


resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.p1_s3_bucket.id
  key          = "error.html"
  source       = "error.html"
  acl          = "public-read"
  content_type = "text/html"
  depends_on = [
    aws_s3_bucket.p1_s3_bucket,
    aws_s3_bucket_ownership_controls.p1_s3_bucket_ownership,
    aws_s3_bucket_public_access_block.p1_s3_bucket_public_access
  ]

}

resource "aws_s3_object" "salsa_image" {
  bucket       = aws_s3_bucket.p1_s3_bucket.id
  key          = "salsa-dancers.jpeg"
  source       = "salsa-dancers.jpeg"
  acl          = "public-read"
  content_type = "jpeg"
  depends_on = [
    aws_s3_bucket.p1_s3_bucket,
    aws_s3_bucket_ownership_controls.p1_s3_bucket_ownership,
    aws_s3_bucket_public_access_block.p1_s3_bucket_public_access
  ]

}

resource "aws_s3_bucket_website_configuration" "p1_s3_bucket_web_config" {
  bucket = aws_s3_bucket.p1_s3_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  depends_on = [
    aws_s3_bucket_ownership_controls.p1_s3_bucket_ownership,
    aws_s3_bucket_public_access_block.p1_s3_bucket_public_access
  ]
}
