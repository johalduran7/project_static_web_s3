resource "aws_s3_bucket" "p1_s3_bucket" {
  bucket = "p1-web-static-bucket"

  tags = {
    Name        = "Project 1 static website"
    Environment = "Dev"
  }
}