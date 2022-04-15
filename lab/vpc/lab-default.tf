provider "aws" {
  region  = "ap-northeast-2"
}

resource "aws_vpc" "lab-vpc" {
  cidr_block       = "172.72.0.0/16"

  tags = {
    Name = "lab-vpc"
  }
}

resource "aws_subnet" "lab-public-a" {
  vpc_id     = aws_vpc.lab-vpc.id
  cidr_block = "172.72.11.0/24"

  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "lab-public-a"
  }
}

resource "aws_subnet" "lab-public-b" {
  vpc_id     = aws_vpc.lab-vpc.id
  cidr_block = "172.72.12.0/24"

  availability_zone = "ap-northeast-2b"

  tags = {
    Name = "lab-public-b"
  }
}

resource "aws_internet_gateway" "lab-igw" {
  vpc_id = aws_vpc.lab-vpc.id

  tags = {
    Name = "lab-igw"
  }
}

resource "aws_route_table" "lab-rt-public" {
  vpc_id = aws_vpc.lab-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lab-igw.id
  }

  tags = {
    Name = "lab-rt-public"
  }
}

resource "aws_route_table_association" "rt-association-public-a" {
  subnet_id      = aws_subnet.lab-public-a.id
  route_table_id = aws_route_table.lab-rt-public.id
}

resource "aws_route_table_association" "rt-association-public-b" {
  subnet_id      = aws_subnet.lab-public-b.id
  route_table_id = aws_route_table.lab-rt-public.id
}

resource "aws_subnet" "lab-private-a" {
  vpc_id     = aws_vpc.lab-vpc.id
  cidr_block = "172.72.21.0/24"

  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "lab-private-a"
  }
}

resource "aws_subnet" "lab-private-b" {
  vpc_id     = aws_vpc.lab-vpc.id
  cidr_block = "172.72.22.0/24"

  availability_zone = "ap-northeast-2b"

  tags = {
    Name = "lab-private-b"
  }
}

resource "aws_subnet" "lab-eks-a" {
  vpc_id     = aws_vpc.lab-vpc.id
  cidr_block = "172.72.31.0/24"

  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "lab-eks-a"
  }
}

resource "aws_subnet" "lab-eks-b" {
  vpc_id     = aws_vpc.lab-vpc.id
  cidr_block = "172.72.32.0/24"

  availability_zone = "ap-northeast-2b"

  tags = {
    Name = "lab-eks-b"
  }
}

resource "aws_eip" "lab-eip-nat-a" {
  vpc   = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eip" "lab-eip-nat-b" {
  vpc   = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "lab-natgw-a" {
  allocation_id = aws_eip.lab-eip-nat-a.id

  # Private subnet이 아니라 public subnet을 연결하셔야 합니다.
  subnet_id = aws_subnet.lab-public-a.id

  tags = {
    Name = "lab-natgw-a"
  }
}

resource "aws_nat_gateway" "lab-natgw-b" {
  allocation_id = aws_eip.lab-eip-nat-b.id

  subnet_id = aws_subnet.lab-public-b.id

  tags = {
    Name = "lab-natgw-b"
  }
}

resource "aws_route_table" "lab-rt-private-a" {
  vpc_id = aws_vpc.lab-vpc.id

  tags = {
    Name = "lab-rt-private-a"
  }
}

resource "aws_route_table" "lab-rt-private-b" {
  vpc_id = aws_vpc.lab-vpc.id

  tags = {
    Name = "lab-rt-private-b"
  }
}

resource "aws_route_table_association" "rt-association-private-a" {
  subnet_id      = aws_subnet.lab-private-a.id
  route_table_id = aws_route_table.lab-rt-private-a.id
}

resource "aws_route_table_association" "rt-association-private-b" {
  subnet_id      = aws_subnet.lab-private-b.id
  route_table_id = aws_route_table.lab-rt-private-b.id
}

resource "aws_route_table_association" "rt-association-eks-a" {
  subnet_id      = aws_subnet.lab-eks-a.id
  route_table_id = aws_route_table.lab-rt-private-a.id
}

resource "aws_route_table_association" "rt-association-eks-b" {
  subnet_id      = aws_subnet.lab-eks-b.id
  route_table_id = aws_route_table.lab-rt-private-b.id
}

resource "aws_route" "private-nat-a" {
  route_table_id              = aws_route_table.lab-rt-private-a.id
  destination_cidr_block      = "0.0.0.0/0"
  nat_gateway_id              = aws_nat_gateway.lab-natgw-a.id
}

resource "aws_route" "private-nat-b" {
  route_table_id              = aws_route_table.lab-rt-private-b.id
  destination_cidr_block      = "0.0.0.0/0"
  nat_gateway_id              = aws_nat_gateway.lab-natgw-b.id
}