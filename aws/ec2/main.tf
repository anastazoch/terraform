data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20221212"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_ebs_volume" "my_ebs_volume" {
  availability_zone = var.availabilityZone
  size              = 100

  tags = {
    Name = "aws-ec2-tf-example"
  }
}

resource "aws_instance" "my_instance" {
  ami                   = data.aws_ami.ubuntu.id
  instance_type         = var.instanceType
  iam_instance_profile  = aws_iam_instance_profile.my_profile.name

  #network_interface {
  #  network_interface_id = aws_network_interface.my_net_iface.id
  #  device_index         = 0
  #}

  depends_on = [aws_internet_gateway.my_gw]

  tags = {
    Name = "aws-ec2-tf-example"
  }
}

resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpcCIDRBlock

  tags = {
    Name = "aws-ec2-tf-example"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.subnetCIDRBlock
  availability_zone = var.availabilityZone

  tags = {
    Name = "aws-ec2-tf-example"
  }
}

resource "aws_subnet" "secondary_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.secondarySubnetCIDRBlock
  availability_zone = var.secondaryAvailabilityZone

  tags = {
    Name = "aws-ec2-tf-example"
  }
}

resource "aws_network_interface" "my_net_iface" {
  subnet_id   = aws_subnet.subnet.id
  private_ips = var.privateIPs

  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_security_group_rule" "allow_tls" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.ingressCIDRBlocks
  security_group_id = aws_security_group.sg.id
}

resource "aws_security_group_rule" "allow_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = var.egressCIDRBlocks
  security_group_id = aws_security_group.sg.id
}

resource "aws_security_group" "sg" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id
}

resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = aws_security_group.sg.id
  network_interface_id = aws_instance.my_instance.primary_network_interface_id
}

resource "aws_eip" "my_eip" {
  instance                  = aws_instance.my_instance.id
  vpc                       = true
  associate_with_private_ip = var.privateIPs[0]
}

resource "aws_internet_gateway" "my_gw" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_lb" "my_alb" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg.id]
  subnets            = [aws_subnet.subnet.id, aws_subnet.secondary_subnet.id]
}

resource "aws_launch_configuration" "as_conf" {
  name          = "web_config"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instanceType
}

resource "aws_autoscaling_group" "my_asg" {
  launch_configuration      = aws_launch_configuration.as_conf.id
  availability_zones        = [var.availabilityZone, var.secondaryAvailabilityZone]
  desired_capacity          = var.asGrpDesiredCapacity
  max_size                  = var.asGrpMaxSize
  min_size                  = var.asGrpMinSize
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = true
  termination_policies      = ["OldestInstance"]
  load_balancers            = ["${aws_lb.my_alb.id}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_schedule" "scale_out_in_business_hours" {
  scheduled_action_name  = "scale-out-during-business-hours"
  min_size               = 2
  max_size               = 10
  desired_capacity       = 5
  recurrence             = "0 9 * * *"
  autoscaling_group_name = aws_autoscaling_group.my_asg.name
}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
  scheduled_action_name  = "scale-in-during-off-hours"
  min_size               = 2
  max_size               = 5
  desired_capacity       = 2
  recurrence             = "0 17 * * *"
  autoscaling_group_name = aws_autoscaling_group.my_asg.name
}    

