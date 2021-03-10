#
# VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Route Table
#

resource "aws_vpc" "sbx" {
  cidr_block = "10.0.0.0/16"

  tags = map(
    "Name", "eks-sbx-vpc",
    "kubernetes.io/cluster/${var.cluster-name}", "shared",
  )
}

resource "aws_subnet" "sbx" {
  count = 2

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.sbx.id

  tags = map(
    "Name", "eks-sbx-subnet-${count.index}",
    "kubernetes.io/cluster/${var.cluster-name}", "shared",
  )
}

resource "aws_internet_gateway" "sbx" {
  vpc_id = aws_vpc.sbx.id

  tags = {
    Name = "terraform-eks-sbx"
  }
}

resource "aws_route_table" "sbx" {
  vpc_id = aws_vpc.sbx.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sbx.id
  }
}

resource "aws_route_table_association" "sbx" {
  count = 2

  subnet_id      = aws_subnet.sbx.*.id[count.index]
  route_table_id = aws_route_table.sbx.id
}
