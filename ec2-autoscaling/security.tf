resource "aws_security_group" "test_alb_sec_grp" {
  name        = local.alb_security_group
  description = "ALB Security Group"
  vpc_id      = aws_vpc.test_vpc.id

  ingress {
    description = "HTTP from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = local.alb_security_group
  }
}

resource "aws_security_group" "test_asg_sec_grp" {
  name        = local.asg_security_group
  description = "ASG Security Group"
  vpc_id      = aws_vpc.test_vpc.id

  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.test_alb_sec_grp.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = local.asg_security_group
  }
}