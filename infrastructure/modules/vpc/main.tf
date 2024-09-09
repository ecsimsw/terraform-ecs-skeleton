# vpc

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "ecsimsw-dev",
    Team = "Server",
    Service = "ecsimsw-platform",
    CreatedBy = "jinhwanKim",
    CreatedAt = "20240903",
  }
}

# internet gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "ecsimsw-dev-main-igw"
  }
}

# nat gateway

resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "ecsimsw-dev-nat-eip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_2a.id

  tags = {
    Name = "ecsimsw-dev-nat"
  }
}

# subnets

resource "aws_subnet" "public_subnet_2a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_2a_cidr_block
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "ecsimsw-dev-public-2a"
  }
}

resource "aws_subnet" "public_subnet_2c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_2c_cidr_block
  availability_zone       = "ap-northeast-2c"
  map_public_ip_on_launch = true

  tags = {
    Name = "ecsimsw-dev-public-2c"
  }
}

resource "aws_subnet" "private_subnet_2a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_2a_cidr_block
  availability_zone       = "ap-northeast-2a"

  tags = {
    Name = "ecsimsw-dev-private-2a"
  }
}

resource "aws_subnet" "private_subnet_2c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_2c_cidr_block
  availability_zone       = "ap-northeast-2c"

  tags = {
    Name = "ecsimsw-dev-private-2c"
  }
}

# route table - IGW/PBL-S

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "ecsimsw-dev-public-rt"
  }
}

resource "aws_route_table_association" "public_subnet_assoc_2a" {
  subnet_id      = aws_subnet.public_subnet_2a.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_assoc_2c" {
  subnet_id      = aws_subnet.public_subnet_2c.id
  route_table_id = aws_route_table.public_route_table.id
}

# route table - NAT/PRV-S

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "ecsimsw-dev-private-rt"
  }
}

resource "aws_route_table_association" "private_subnet_assoc_2a" {
  subnet_id      = aws_subnet.private_subnet_2a.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_subnet_assoc_2c" {
  subnet_id      = aws_subnet.private_subnet_2c.id
  route_table_id = aws_route_table.private_route_table.id
}