resource "aws_s3_bucket" "image_bucket" {
  bucket = "gachon-link-image-bucket"
  force_destroy = false  
  

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [tags, versioning]
  }


  tags = {
    Name        = "prioject image bucket"
    Environment = "Dev"
  }

}

resource "aws_s3_bucket_public_access_block" "access_block" {
  bucket                  = aws_s3_bucket.image_bucket.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "version" {
  bucket = aws_s3_bucket.image_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
