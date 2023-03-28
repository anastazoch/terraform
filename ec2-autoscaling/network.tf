resource "aws_vpc" "test_vpc" {
  cidr_block = var.vpcCIDR

  tags = {
    Name = local.vpc
  }
}

resource "aws_internet_gateway" "test_igw" {
  vpc_id = aws_vpc.test_vpc.id

  tags = {
    Name = local.internet_gateway
  }
}

resource "aws_subnet" "test_pub_sub" {
  count                   = length(var.availabilityZones)
  vpc_id                  = aws_vpc.test_vpc.id
  cidr_block              = var.pubSubCIDR[count.index]
  map_public_ip_on_launch = true
  availability_zone       = var.availabilityZones[count.index]

  tags = {
    Name = join("-", [local.public_subnet, var.availabilityZones[count.index]])
  }
}

resource "aws_subnet" "test_priv_sub" {
  count             = length(var.availabilityZones)
  vpc_id            = aws_vpc.test_vpc.id
  cidr_block        = var.privSubCIDR[count.index]
  availability_zone = var.availabilityZones[count.index]

  tags = {
    Name = join("-", [local.private_subnet, var.availabilityZones[count.index]])
  }
}

resource "aws_route_table" "test_pub_rt" {
  vpc_id = aws_vpc.test_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test_igw.id
  }
  
    tags = {
    Name = local.public_route_table
  }
}

resource "aws_eip" "test_eip" {
  vpc = true

  tags = {
    Name = local.elastic_ip
  }
}

resource "aws_nat_gateway" "test_nat_gw" {
  allocation_id     = aws_eip.test_eip.id
  connectivity_type = "public"
  subnet_id         = aws_subnet.test_pub_sub[0].id

  tags = {
    Name = local.nat_gateway
  }

  depends_on = [aws_internet_gateway.test_igw]
}

resource "aws_route_table" "test_priv_rt" {
  vpc_id = aws_vpc.test_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.test_nat_gw.id
  }
  
  tags = {
    Name = local.private_route_table
  }
}

resource "aws_route_table_association" "test_pub_rt_assoc" {
  count          = length(var.availabilityZones)
  subnet_id      = aws_subnet.test_pub_sub[count.index].id
  route_table_id = aws_route_table.test_pub_rt.id
}

resource "aws_route_table_association" "test_priv_rt_assoc" {
  count          = length(var.availabilityZones)
  subnet_id      = aws_subnet.test_priv_sub[count.index].id
  route_table_id = aws_route_table.test_priv_rt.id
}