resource "aws_s3_bucket" "my_s3_bucket" {
  bucket = "my-test-temp-ec2-bucket"
}

resource "aws_s3_bucket_acl" "my_bucket_acl" {
  bucket = aws_s3_bucket.my_s3_bucket.id
  acl    = "private"
}
resource "aws_iam_policy" "my_s3_policy" {
  name        = "S3-Bucket-Access-Policy"
  description = "Provides permission to access S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Effect   = "Allow"
        Resource = [ "arn:aws:s3:::ec2_bucket" ]
      },
      {
        Action: [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ]
        Effect   = "Allow",
        Resource = [ "arn:aws:s3:::ec2_bucket/*" ]
      }
    ]
  })
}

resource "aws_iam_role" "my_role" {
  name = "ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy_attachment" "my_policy_attach" {
  name       = "my_policy_attach"
  roles      = [aws_iam_role.my_role.name]
  policy_arn = aws_iam_policy.my_s3_policy.arn
}

resource "aws_iam_instance_profile" "my_profile" {
  name = "ec2_profile"
  role = aws_iam_role.my_role.name
}
