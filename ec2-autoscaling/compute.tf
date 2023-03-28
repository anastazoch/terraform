resource "aws_launch_template" "test_lnch_tmlp" {
  name          = local.launch_template
  image_id      = var.ami
  instance_type = var.instType

  network_interfaces {
    device_index    = 0
    security_groups = [aws_security_group.test_alb_sec_grp.id]
  }
  tag_specifications {
    resource_type = "instance"

    tags = {
    Name = local.launch_template_ec2
    }
  }

 user_data = filebase64("${path.module}/install-apache.sh")
}

resource "aws_autoscaling_group" "test_asc_grp" {
  desired_capacity    = var.desiredCapacity
  max_size            = var.maxSize
  min_size            = var.minSize
  vpc_zone_identifier = [for i in aws_subnet.test_priv_sub[*] : i.id]
  target_group_arns   = [aws_lb_target_group.test_alb_tgt_grp.arn]

  launch_template {
    id      = aws_launch_template.test_lnch_tmlp.id
    version = aws_launch_template.test_lnch_tmlp.latest_version
  }
}