provider "aws" {
   region = "us-east-1"
   access_key = "AKIAWI7TGBPHMYZ2CGHW"
   secret_key = "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"
}

#1. create vpc
resource "aws_vpc" "SharedService_vpc" {
  cidr_block = "172.21.0.0/16"
  tags = {
    "name" = "SharedService-vpc"
  }
}

#2. create internet gateway
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.SharedService_vpc.id

  tags = {
    Name = "sharedservice"
  }
}

#3. route tablet private
resource "aws_route_table" "rtss_private" {
  vpc_id = aws_vpc.SharedService_vpc.id
    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id             = aws_internet_gateway.ig.id
  }

  tags = {
    Name = "sharedservice_rt_private"
  }

}

#4. created private subnets a,b,c
resource "aws_subnet" "private_subnet_a" {
  vpc_id     = aws_vpc.SharedService_vpc.id
  cidr_block = "172.21.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "sharedservice-sn-pvta"
  }
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id     = aws_vpc.SharedService_vpc.id
  cidr_block = "172.21.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "sharedservice-sn-pvtb"
  }
}

resource "aws_subnet" "private_subnet_c" {
  vpc_id     = aws_vpc.SharedService_vpc.id
  cidr_block = "172.21.3.0/24"
  availability_zone = "us-east-1c"
  tags = {
    Name = "husharedb-sn-pvtc"
  }
}

#5. associate subnet with route table
resource "aws_route_table_association" "rt_private_a" {
  subnet_id      = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.rtss_private.id
}

resource "aws_route_table_association" "rt_private_b" {
  subnet_id      = aws_subnet.private_subnet_b.id
  route_table_id = aws_route_table.rtss_private.id
}
resource "aws_route_table_association" "rt_private_c" {
  subnet_id      = aws_subnet.private_subnet_c.id
  route_table_id = aws_route_table.rtss_private.id
}