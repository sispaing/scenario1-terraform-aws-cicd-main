# --- Networking ---
resource "aws_subnet" "private" {
  vpc_id            = data.aws_vpc.default.id
  cidr_block        = "172.31.101.0/24"
  availability_zone = "${var.aws_region}a"
  tags              = { Name = "${var.project_name}-private-subnet" }
}

resource "aws_route_table" "private" {
  vpc_id = data.aws_vpc.default.id

  tags = {
    Name = "${var.project_name}-private-route-table"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = data.aws_vpc.default.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  route_table_ids   = [aws_route_table.private.id]
  vpc_endpoint_type = "Gateway"

  tags = {
    Name = "S3 VPC Endpoint"
  }
}