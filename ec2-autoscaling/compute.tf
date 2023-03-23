resource "aws_launch_template" "test_lnch_tmlp" {
  name          = local.launch_template_name
  image_id      = var.ami
  instance_type = var.instance_type

  network_interfaces {
    device_index    = 0
    security_groups = [aws_security_group.asg_security_group.id]
  }
  tag_specifications {
    resource_type = "instance"

    tags = {
    Name = local.launch_template_ec2_name
    }
  }

 user_data = filebase64("${path.module}/install-apache.sh")
}

resource "aws_autoscaling_group" "auto_scaling_group" {
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  vpc_zone_identifier = [for i in aws_subnet.private_subnet[*] : i.id]
  target_group_arns   = [aws_lb_target_group.target_group.arn]

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = aws_launch_template.launch_template.latest_version
  }
}