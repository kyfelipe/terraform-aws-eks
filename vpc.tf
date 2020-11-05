data "aws_availability_zones" "available" { }

resource "aws_vpc" "eks" {
  cidr_block = "10.0.0.0/16"

  tags = map(
    "Name", "${local.vpc_name}",
    "project", "${var.project}"
  )
}

resource "aws_subnet" "eks" {
  count                   = var.number_of_subnets
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = cidrsubnet(aws_vpc.eks.cidr_block, 8, count.index)
  vpc_id                  = aws_vpc.eks.id

  tags = map(
    "Name", "${local.subnet_name}",
    "project", "${var.project}",
    "kubernetes.io/cluster/${local.cluster_name}", "shared"
  )
}

resource "aws_internet_gateway" "eks" {
  vpc_id = aws_vpc.eks.id

  tags = {
    Name    = local.igw_name
    project = var.project
  }
}

resource "aws_route_table" "eks" {
  vpc_id = aws_vpc.eks.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks.id
  }
}

resource "aws_route_table_association" "eks" {
  count = var.number_of_subnets

  subnet_id      = aws_subnet.eks[count.index].id
  route_table_id = aws_route_table.eks.id
}
