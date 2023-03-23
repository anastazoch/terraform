resource "aws_s3_bucket" "test_super_alb" {
  bucket = "test-super-alb"

  tags = {
    Name        = "test_super_alb"
    Environment = "Production"
  }
}

resource "aws_lb" "test_alb" {
  name               = "test-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.test_alb_allow_tls.id]
  subnets            = [for subnet in aws_subnet.test_alb_pub_sub : subnet.id]

  enable_deletion_protection = true

  access_logs {
    bucket  = aws_s3_bucket.test_super_alb.id
    prefix  = "test-alb"
    enabled = true
  }

  tags = {
    Environment = "production"
  }
}