resource "aws_vpc" "test_vpc" {               
  cidr_block       = var.vcp_cidr
  instance_tenancy = "default"
}

resource "aws_internet_gateway" "test_inet_gw" {
  vpc_id = aws_vpc.test_vpc.id
}

resource "aws_eip" "test_nat_ext_ip" {
  vpc = true
}

resource "aws_nat_gateway" "test_nat_gw" {
  allocation_id = aws_eip.test_nat_ext_ip.id
  subnet_id = aws_subnet.test_priv_sub.id
}

resource "aws_subnet" "test_pub_sub" {
  vpc_id     =  aws_vpc.test_vpc.id
  cidr_block = var.public_subnet
}

resource "aws_subnet" "test_priv_sub" {
  vpc_id     =  aws_vpc.test_vpc.id
  cidr_block = var.private_subnet
}

resource "aws_route_table" "test_rt_pub" {
  vpc_id =  aws_vpc.test_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test_inet_gw.id
  }
}

resource "aws_route_table" "test_rt_priv" {
  vpc_id = aws_vpc.test_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.test_nat_gw.id
  }
}

resource "aws_route_table_association" "test_rt_assoc_pub" {
  subnet_id       = aws_subnet.test_pub_sub.id
  route_table_id  = aws_route_table.test_rt_pub.id
}

resource "aws_route_table_association" "test_rt_assoc_priv" {
  subnet_id       = aws_subnet.test_priv_sub.id
  route_table_id  = aws_route_table.test_rt_priv.id
}

data "aws_availability_zones" "available" {}

resource "aws_vpc" "test_alb_vpc" {
  cidr_block           = "172.32.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_subnet" "test_alb_pub_sub" {
  count = "${length(data.aws_availability_zones.available.names)}"
  vpc_id = aws_vpc.test_alb_vpc.id
  cidr_block = "172.32.${10 + count.index}.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  map_public_ip_on_launch = true
  tags = {
    Name = "alb_pub_sub"
  }
}

resource "aws_subnet" "test_alb_priv_sub" {
  count = "${length(data.aws_availability_zones.available.names)}"
  vpc_id = aws_vpc.test_alb_vpc.id
  cidr_block = "172.32.${20 + count.index}.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  map_public_ip_on_launch = true
  tags = {
    Name = "alb_priv_sub"
  }
}