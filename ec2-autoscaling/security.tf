resource "aws_security_group" "alb_security_group" {
  name        = local.alb_security_group_name
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
    Name = local.alb_security_group_name
  }
}

resource "aws_security_group" "test_asg_sec_grp" {
  name        = local.asg_security_group_name
  description = "ASG Security Group"
  vpc_id      = aws_vpc.test_vpc.id

  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_security_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = local.asg_security_group_name
  }
}