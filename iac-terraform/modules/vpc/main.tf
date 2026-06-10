# Define vpc to allocate eks cluster
resource "aws_vpc" "this-petshop-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# Public subnet
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidr)
  vpc_id                  = aws_vpc.this-petshop-vpc.id
  cidr_block              = var.public_subnet_cidr[count.index]
  map_public_ip_on_launch = true
  availability_zone       = var.azs[count.index]
  tags = {
    Name = "${var.project_name}-public-subnet"
    type = "public"
  }
}

# Private subnet
resource "aws_subnet" "private" {
  count                   = length(var.private_subnet_cidr)
  vpc_id                  = aws_vpc.this-petshop-vpc.id
  cidr_block              = var.private_subnet_cidr[count.index]
  map_public_ip_on_launch = false
  availability_zone       = var.azs[count.index]
  tags = {
    Name = "${var.project_name}-private-subnet"
    type = "private"
  }
}

# Internet gateway
resource "aws_internet_gateway" "this-igw" {
  vpc_id = aws_vpc.this-petshop-vpc.id
  tags = {
    Name = "${var.project_name}-igw"
  }
}

# Nat gateway & Elastic ip
resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = {
    Name = "${var.project_name}-nat-eip"
  }
}
resource "aws_nat_gateway" "nat_gtw" {
  depends_on    = [aws_internet_gateway.this-igw]
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public[0].id # In public sub
  tags = {
    Name        = "${var.project_name}-nat-gateway"
    Description = "To reach internet from private subnet"
  }
}


# Routes table

resource "aws_route_table" "private-rt" { #Private subnet route table
  vpc_id = aws_vpc.this-petshop-vpc.id

  # Internal comunication
  route {
    cidr_block = var.vpc_cidr
    gateway_id = "local"
  }
  # To internet
  route {
    cidr_block     = "0.0.0.0/0"                # Destination
    nat_gateway_id = aws_nat_gateway.nat_gtw.id # Target
  }
  tags = {
    Description = "Private subnet route table"
    Name        = "${var.project_name}-private-rt"
  }
}


resource "aws_route_table" "public-rt" { #Public subnet route table
  vpc_id = aws_vpc.this-petshop-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this-igw.id
  }
  tags = {
    Description = "Public subnet route table"
    Name        = "${var.project_name}-pubblic-rt"
  }
}

# Route table association
resource "aws_route_table_association" "pblc-rt-association" {
  count          = length(var.public_subnet_cidr)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "prvt-rt-association" {
  count          = length(var.private_subnet_cidr)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private-rt.id
}
