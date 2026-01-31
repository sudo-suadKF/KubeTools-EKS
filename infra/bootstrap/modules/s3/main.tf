resource "aws_s3_bucket" "eks-bootstrap" {
  bucket = "eks-bootstrap-bucket-for-terraform-state"
  object_lock_enabled = true
  tags = {
    Name        = "EKS bootstrap bucket"
  }
}

resource "aws_s3_bucket_ownership_controls" "disable-acl" {
  bucket = aws_s3_bucket.eks-bootstrap.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "access-denied" {
  bucket = aws_s3_bucket.eks-bootstrap.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.eks-bootstrap.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sse-s3" {
  bucket =  aws_s3_bucket.eks-bootstrap.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}