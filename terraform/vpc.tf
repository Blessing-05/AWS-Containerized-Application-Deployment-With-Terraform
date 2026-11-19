resource "aws_vpc" "main" {
  enable_dns_hostnames = true
  enable_dns_support = true
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "node-app-deployment-vpc"
  }
}

#2 Creating the internet gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "node-app-deployment-igw"
  }
}

#3 Creating the public subnets
resource "aws_subnet" "pub_sub1" {
  vpc_id = aws_vpc.main.id
  availability_zone = "us-east-1a"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "node-app-deployment-pub-sub1"
  }
}

resource "aws_subnet" "pub_sub2" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "node-app-deployment-pub-sub2"
  }
}

#4 Creating the Private subnet
resource "aws_subnet" "priv_sub1" {
  availability_zone = "us-east-1a"
  cidr_block = "10.0.3.0/24"
  map_public_ip_on_launch = false
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "node-app-deployment-priv-sub1"
  }
}

resource "aws_subnet" "priv_sub2" {
  availability_zone = "us-east-1b"
  cidr_block = "10.0.4.0/24"
  map_public_ip_on_launch = false
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "node-app-deployment-priv-sub2"
  }
}

#5 Creating EIP and Nat Gateway
resource "aws_eip" "main" {
  domain = "vpc"
  depends_on = [ aws_internet_gateway.main ]

  tags = {
    Name = "node-app-deploy-eip"
  }
}

resource "aws_nat_gateway" "main" {  #allows priv sub tasks to reach ecr
  allocation_id = aws_eip.main.id
  subnet_id = aws_subnet.priv_sub1.id
  depends_on = [ aws_internet_gateway.main ]

  tags = {
    Name = "nat-gateway"
  }
}

#6 Creating the public route table
resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "pub-rt"
  }
}

#7 Creating private rt
resource "aws_route_table" "priv_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "priv-rt"
  }
}

#8 Pub rt association
resource "aws_route_table_association" "pub_sub1_association" {
  subnet_id = aws_subnet.pub_sub1.id
  route_table_id = aws_route_table.pub_rt.id
}
resource "aws_route_table_association" "pub_sub2_association" {
  subnet_id = aws_subnet.pub_sub2.id
  route_table_id = aws_route_table.pub_rt.id
}

#9 Priv rt association
resource "aws_route_table_association" "priv_sub1_association" {
  subnet_id = aws_subnet.priv_sub1.id
  route_table_id = aws_route_table.priv_rt.id
}
resource "aws_route_table_association" "priv_sub2_association" {
  subnet_id = aws_subnet.priv_sub2.id
  route_table_id = aws_route_table.priv_rt.id
}