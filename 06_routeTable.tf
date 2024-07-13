resource "aws_route_table" "rtb-public" {
  vpc_id = aws_vpc.vpc-main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

}
resource "aws_route_table" "rtb-internal" {
  vpc_id = aws_vpc.vpc-main.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }

}

# Associate the route table with the public subnet
resource "aws_route_table_association" "associate_public_1a" {
  subnet_id      = aws_subnet.public-subnet-1a.id
  route_table_id = aws_route_table.rtb-public.id

}
resource "aws_route_table_association" "associate_private_1a" {
  subnet_id = aws_subnet.private-subnet-1a.id
  route_table_id = aws_route_table.rtb-internal.id
}
resource "aws_route_table_association" "associate_public_1b" {
  subnet_id = aws_subnet.private-subnet-1b.id
  route_table_id = aws_route_table.rtb-internal.id
}
