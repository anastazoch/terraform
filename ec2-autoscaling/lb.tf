resource "aws_lb" "test_alb" {
  name               = local.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_security_group.id]
  subnets            = [for i in aws_subnet.public_subnet : i.id]
}

resource "aws_lb_target_group" "test_alb_tgt_grp" {
  name     = local.target_group_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    path    = "/"
    matcher = 200
  }
}

resource "aws_lb_listener" "test_alb_listener" {
  load_balancer_arn = aws_lb.test_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test_alb_tgt_grp.arn
  }
}