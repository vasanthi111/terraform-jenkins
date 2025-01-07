provider "aws" {
  region = var.region
}
resource "aws_internet_gateway" "demogateway" {
vpc_id="${aws_vpc.demovpc.id}"
tags={
Name="Internet Gateway"
}
}
resource "aws_route_table" "route" {
vpc_id="${aws_vpc.demovpc.id}"
route{
cidr_block="0.0.0.0/0"
gateway_id="${aws_internet_gateway.demogateway.id}"
}
tags={
Name="Route to Internet"
}
}

resource "aws_route_table_association" "rt1" {
subnet_id="${aws_subnet.public_subnet-1.id}"
route_table_id="${aws_route_table.route.id}"
}
