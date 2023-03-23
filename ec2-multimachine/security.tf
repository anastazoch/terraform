resource "aws_security_group" "test_priv_sg" {
  name        = "allow_all_out"
  description = "Allow all outbound traffic"
  vpc_id      = aws_vpc.test_vpc.id
}

resource "aws_security_group_rule" "test_priv_sg_rule_allow_all_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = [aws_subnet.test_priv_sub.cidr_block]
  security_group_id = aws_security_group.test_priv_sg.id
}

resource "aws_security_group_rule" "test_priv_sg_rule_allow_all_from_pub" {
  type                      = "ingress"
  from_port                 = 0
  to_port                   = 65535
  protocol                  = "tcp"
  source_security_group_id  = aws_security_group.test_pub_sg.id
  security_group_id         = aws_security_group.test_priv_sg.id
}

resource "aws_security_group" "test_pub_sg" {
  name        = "allow_tls_in"
  description = "Allow SSH, and HTTPS inbound traffic"
  vpc_id      = aws_vpc.test_vpc.id
}

resource "aws_security_group_rule" "test_pub_sg_rule_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [aws_subnet.test_pub_sub.cidr_block]
  security_group_id = aws_security_group.test_pub_sg.id
}

resource "aws_security_group_rule" "test_pub_sg_rule_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.test_pub_sg.id
}

resource "aws_security_group_rule" "test_pub_sg_rule_icmp" {
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.test_pub_sg.id
}

resource "aws_network_acl" "test_priv_net_acl" {
  vpc_id = aws_vpc.test_vpc.id
}

resource "aws_network_acl_rule" "test_priv_net_acl_rule" {
  network_acl_id = aws_network_acl.test_priv_net_acl.id
  rule_number    = 100
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = aws_subnet.test_priv_sub.cidr_block
  from_port      = 0
  to_port        = 65535
}

resource "aws_network_acl" "test_pub_net_acl" {
  vpc_id = aws_vpc.test_vpc.id
}

resource "aws_network_acl_rule" "test_pub_net_acl_rule_https" {
  network_acl_id = aws_network_acl.test_pub_net_acl.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = aws_subnet.test_pub_sub.cidr_block
  from_port      = 443
  to_port        = 443
}

resource "aws_network_acl_rule" "test_pub_net_acl_rule_ssh" {
  network_acl_id = aws_network_acl.test_pub_net_acl.id
  rule_number    = 101
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = aws_subnet.test_pub_sub.cidr_block
  from_port      = 22
  to_port        = 22
}

resource "aws_security_group" "test_alb_allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.test_alb_vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.test_alb_vpc.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}