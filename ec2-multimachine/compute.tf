data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "test_kp" {
  key_name   = "test key pair"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

resource "aws_network_interface" "test_priv_net_int" {
  subnet_id   = aws_subnet.test_priv_sub.id
  count       = var.private_instance_count

  tags = {
    Name = "private-network-interface-${count.index - 1}"
  }
}

resource "aws_network_interface_sg_attachment" "test_priv_sg_attachment" {
  count                = var.private_instance_count
  security_group_id    = aws_security_group.test_priv_sg.id
  network_interface_id = aws_instance.test_priv_ec2_inst[count.index].primary_network_interface_id
}

resource "aws_instance" "test_priv_ec2_inst" {
  ami           = data.aws_ami.ubuntu.id
  count         = var.private_instance_count
  instance_type = var.instance_type
  key_name      = aws_key_pair.test_kp.key_name

  network_interface {
    network_interface_id = aws_network_interface.test_priv_net_int[count.index].id
    device_index         = 0
  }

  credit_specification {
    cpu_credits = "unlimited"
  }

  tags = {
    Name = "private-vm-${count.index - 1}"
  }
}

resource "aws_network_interface" "test_pub_net_int" {
  subnet_id   = aws_subnet.test_pub_sub.id
  count       = var.public_instance_count

  tags = {
    Name = "public-network-interface-${count.index}"
  }
}

resource "aws_network_interface_sg_attachment" "test_pub_sg_attachment" {
  count                = var.public_instance_count
  security_group_id    = aws_security_group.test_pub_sg.id
  network_interface_id = aws_instance.test_pub_ec2_inst[count.index].primary_network_interface_id
}

resource "aws_instance" "test_pub_ec2_inst" {
  ami           = data.aws_ami.ubuntu.id
  count         = var.public_instance_count
  instance_type = var.instance_type
  key_name      = aws_key_pair.test_kp.key_name

  network_interface {
    network_interface_id = aws_network_interface.test_pub_net_int[count.index].id
    device_index         = 0
  }

  credit_specification {
    cpu_credits = "unlimited"
  }

  tags = {
    Name = "public-vm-${count.index}"
  }
}

resource "aws_eip" "test_eip" {
  count             = var.public_instance_count
  instance          = aws_instance.test_pub_ec2_inst[count.index].id
  vpc               = true

  depends_on = [aws_internet_gateway.test_inet_gw, aws_instance.test_pub_ec2_inst]
}

resource "aws_lb" "test_priv_lb" {
  name               = "test-private-nlb"
  load_balancer_type = "network"

  dynamic subnet_mapping {
    for_each = { for key, value in aws_instance.test_priv_ec2_inst:
                  key => { subnet_id = value.subnet_id }
               }
    
    content {
      subnet_id            = subnet_mapping.value.subnet_id
      private_ipv4_address = aws_instance.test_priv_ec2_inst[subnet_mapping.key].private_ip
    }
  }
}

resource "aws_lb" "test_pub_alb" {
  name               = "test-public-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.test_pub_sg.id]
  subnets            = [aws_subnet.test_pub_sub.id]

  enable_deletion_protection = true
}