resource "aws_vpc" "test" {
  cidr_block = "10.0.0.0/16"

  enable_dns_support                   = true
  enable_dns_hostnames                 = true
  enable_network_address_usage_metrics = true

  tags = {
    Name = "test-vpc"
  }
}
#----------

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.test.id

  tags = {
    Name = "test-igw"
  }
}
#---------------

resource "aws_subnet" "pub_a" {
  vpc_id            = aws_vpc.test.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "ap-northeast-2a"
  #map_public_ip_on_launch = true 

  tags = {
    Name                   = "test-pub_a"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "pub_c" {
  vpc_id            = aws_vpc.test.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-northeast-2c"
  #map_public_ip_on_launch = true

  tags = {
    Name                   = "test-pub_c"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "pri_a" {
  vpc_id            = aws_vpc.test.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name                            = "test-pri_a"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "pri_c" {
  vpc_id            = aws_vpc.test.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name                            = "test-pri_c"
    "kubernetes.io/role/internal-elb" = "1"
  }
}
#-------------

resource "aws_eip" "nat_a" {
  domain = "vpc"

  tags = {
    Name = "test-nat-a-eip"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_eip" "nat_c" {
  domain = "vpc"

  tags = {
    Name = "test-nat-c-eip"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat_a" {
  allocation_id = aws_eip.nat_a.id
  subnet_id     = aws_subnet.pub_a.id

  tags = {
    Name = "test-nat-pub-a"
  }
}

resource "aws_nat_gateway" "nat_c" {
  allocation_id = aws_eip.nat_c.id
  subnet_id     = aws_subnet.pub_c.id

  tags = {
    Name = "test-nat-pub-c"
  }
}
#-------------------

resource "aws_route_table" "pub" {
  vpc_id = aws_vpc.test.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "pub-rtb"
  }
}

resource "aws_route_table" "pri_a" {
  vpc_id = aws_vpc.test.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_a.id
  }

  tags = {
    Name = "test-pri-a-rtb"
  }
}

resource "aws_route_table" "pri_c" {
  vpc_id = aws_vpc.test.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_c.id
  }

  tags = {
    Name = "test-pri-c-rtb"
  }
}
#-------------

resource "aws_route_table_association" "pub_a" {
  subnet_id      = aws_subnet.pub_a.id
  route_table_id = aws_route_table.pub.id
}

resource "aws_route_table_association" "pub_c" {
  subnet_id      = aws_subnet.pub_c.id
  route_table_id = aws_route_table.pub.id
}

resource "aws_route_table_association" "pri_a" {
  subnet_id      = aws_subnet.pri_a.id
  route_table_id = aws_route_table.pri_a.id
}

resource "aws_route_table_association" "pri_c" {
  subnet_id      = aws_subnet.pri_c.id
  route_table_id = aws_route_table.pri_c.id
}
#------------
