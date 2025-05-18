resource "aws_subnet" "public-subnet-a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.vpc["cidr_block"], 8, 1)
  availability_zone       = var.aws_region["az"][0]
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-a"
  }
}

resource "aws_subnet" "public-subnet-b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.vpc["cidr_block"], 8, 2)
  availability_zone       = var.aws_region["az"][1]
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-b"
  }
}

resource "aws_subnet" "private-subnet-a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc["cidr_block"], 8, 3)
  availability_zone = var.aws_region["az"][0]
  tags = {
    Name = "private-subnet-a"
  }
}

resource "aws_subnet" "private-subnet-b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc["cidr_block"], 8, 4)
  availability_zone = var.aws_region["az"][1]
  tags = {
    Name = "private-subnet-b"
  }
}

resource "aws_subnet" "db-subnet-a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc["cidr_block"], 8, 5)
  availability_zone = var.aws_region["az"][0]
  tags = {
    Name = "db-subnet-a"
  }
}

resource "aws_subnet" "db-subnet-b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc["cidr_block"], 8, 6)
  availability_zone = var.aws_region["az"][1]
  tags = {
    Name = "db-subnet-b"
  }
}

output "subnet" {
  value = {
    public-subnet-a  = aws_subnet.public-subnet-a.id
    public-subnet-b  = aws_subnet.public-subnet-b.id
    private-subnet-a = aws_subnet.private-subnet-a.id
    private-subnet-b = aws_subnet.private-subnet-b.id
    db-subnet-a      = aws_subnet.db-subnet-a.id
    db-subnet-b      = aws_subnet.db-subnet-b.id
  }
}