# Create the VPC
resource "aws_vpc" "vpc_primary" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

# Create Subnets
resource "aws_subnet" "subnet" {
  for_each = var.subnet_cidr_blocks

  vpc_id                  = aws_vpc.vpc_primary.id
  cidr_block              = each.value
  availability_zone       = element(var.availability_zones, index(keys(var.subnet_cidr_blocks), each.key))
  map_public_ip_on_launch = each.key == "public"
  tags = {
    Name = "${each.key}-${index(keys(var.subnet_cidr_blocks), each.key)}"
  }
}

# Create Route Tables for Public and Private Subnets
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc_primary.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_primary.id
  }
  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc_primary.id
  tags = {
    Name = "private-route-table"
  }
}

# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public_subnet_rt_associations" {
  for_each = { for k, v in var.subnet_cidr_blocks : k => v if k == "public" }

  subnet_id      = aws_subnet.subnet[each.key].id
  route_table_id = aws_route_table.public_route_table.id
}

# Associate Private Subnets with Private Route Table
resource "aws_route_table_association" "private_subnet_rt_associations" {
  for_each = { for k, v in var.subnet_cidr_blocks : k => v if k == "private" }

  subnet_id      = aws_subnet.subnet[each.key].id
  route_table_id = aws_route_table.private_route_table.id
}

# Create an Internet Gateway
resource "aws_internet_gateway" "igw_primary" {
  vpc_id = aws_vpc.vpc_primary.id
  tags = {
    Name = "igw-main"
  }
}

# Create a NAT Gateway
resource "aws_eip" "nat_eip" {
  count = length(var.availability_zones)
}

resource "aws_nat_gateway" "nat_gw_primary" {
  count         = length(var.availability_zones)
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.subnet["public"].id
  tags = {
    Name = "nat-gateway-${count.index}"
  }
}

# Route for NAT Gateway
resource "aws_route" "nat_route" {
  count                  = length(var.availability_zones)
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw_primary[count.index].id
}

# #Create Security Groups
# resource "aws_security_group" "sg" {
#   for_each = {
#     "web" = {}
#     "db"  = {}
#   }

#   vpc_id = aws_vpc.vpc_primary.id
#   tags = {
#     Name = "${each.key}-sg"
#   }
# }

# #Security Group Rules
# resource "aws_security_group_rule" "sg_rule" {
#   for_each = {
#     "web_ingress" = { sg = "web", from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }
#     "db_ingress"  = { sg = "db", from_port = 3306, to_port = 3306, protocol = "tcp", cidr_blocks = ["10.0.0.0/16"] }
#   }

#   type              = "ingress"
#   from_port         = each.value.from_port
#   to_port           = each.value.to_port
#   protocol          = each.value.protocol
#   security_group_id = aws_security_group.sg[each.value.sg].id
#   cidr_blocks       = each.value.cidr_blocks
# }

# # Custom Route for Peering
# resource "aws_route" "vpc_peering" {
#   route_table_id            = aws_route_table.route_table["external"].id
#   destination_cidr_block    = "10.1.0.0/16"
#   vpc_peering_connection_id = "vpc-secondary" # replace with actual peering connection ID
# }
