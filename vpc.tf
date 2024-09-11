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

# Create Route Tables
resource "aws_route_table" "route_table" {
  for_each = var.subnet_cidr_blocks

  vpc_id = aws_vpc.vpc_primary.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_primary.id
  }
  tags = {
    Name = "${each.key}-route-table"
  }
}

# Associate Subnets with Route Tables
resource "aws_route_table_association" "subnet_rt_associations" {
  for_each = var.subnet_cidr_blocks

  subnet_id      = aws_subnet.subnet[each.key].id
  route_table_id = aws_route_table.route_table[each.key].id
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
  route_table_id         = aws_route_table.route_table["private"].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw_primary[count.index].id
}

# Create Network ACLs
resource "aws_network_acl" "acl" {
  for_each = {
    "apps"    = {}
    "private" = {}
  }

  vpc_id = aws_vpc.vpc_primary.id
  tags = {
    Name = "${each.key}-acl"
  }
}

# Create Network ACL Rules
resource "aws_network_acl_rule" "acl_rule" {
  for_each = {
    "apps_inbound"     = { acl = "apps", egress = false, port = 80 }
    "apps_outbound"    = { acl = "apps", egress = true, port = 80 }
    "private_inbound"  = { acl = "private", egress = false, port = 22 }
    "private_outbound" = { acl = "private", egress = true, port = 22 }
  }

  network_acl_id = aws_network_acl.acl[each.value.acl].id
  rule_number    = 100
  protocol       = "tcp"
  rule_action    = "allow"
  egress         = each.value.egress
  cidr_block     = "0.0.0.0/0"
  from_port      = each.value.port
  to_port        = each.value.port
}

#Create Security Groups
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
