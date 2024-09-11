### Create the VPC ###
resource "aws_vpc" "vpc_primary" {
  cidr_block = var.cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

### Create Subnets ###
resource "aws_subnet" "public" {
  count = length(var.availability_zones)
  vpc_id            = aws_vpc.vpc_primary.id
  cidr_block        = element(values(var.subnet_cidr_blocks), 0)
  availability_zone = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "public-${count.index}"
  }
}

resource "aws_subnet" "private" {
  count = length(var.availability_zones)
  vpc_id            = aws_vpc.vpc_primary.id
  cidr_block        = element(values(var.subnet_cidr_blocks), 1)
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name = "private-${count.index}"
  }
}

resource "aws_subnet" "apps" {
  count = length(var.availability_zones)
  vpc_id            = aws_vpc.vpc_primary.id
  cidr_block        = element(values(var.subnet_cidr_blocks), 2)
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name = "apps-${count.index}"
  }
}

resource "aws_subnet" "external" {
  count = length(var.availability_zones)
  vpc_id            = aws_vpc.vpc_primary.id
  cidr_block        = element(values(var.subnet_cidr_blocks), 3)
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name = "external-${count.index}"
  }
}

### Create Route Tables ###
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc_primary.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_primary.id
  }
  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc_primary.id
  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route_table" "apps" {
  vpc_id = aws_vpc.vpc_primary.id
  tags = {
    Name = "apps-route-table"
  }
}

resource "aws_route_table" "external" {
  vpc_id = aws_vpc.vpc_primary.id
  tags = {
    Name = "external-route-table"
  }
}

### Associate Subnets with Route Tables ###
resource "aws_route_table_association" "subnet_rt_associations" {
  count = length(var.availability_zones) * 4
  subnet_id      = element(concat(aws_subnet.public.*.id, aws_subnet.private.*.id, aws_subnet.apps.*.id, aws_subnet.external.*.id), count.index)
  route_table_id = element([
    aws_route_table.public.id,
    aws_route_table.private.id,
    aws_route_table.apps.id,
    aws_route_table.external.id
  ], count.index % 4)
}

### Create an Internet Gateway ###
resource "aws_internet_gateway" "igw_primary" {
  vpc_id = aws_vpc.vpc_primary.id
  tags = {
    Name = "igw-main"
  }
}

### Create a NAT Gateway ###
resource "aws_eip" "nat_eip" {
  count = length(var.availability_zones)
}

resource "aws_nat_gateway" "nat_gw_primary" {
  count = length(var.availability_zones)
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  tags = {
    Name = "nat-gateway-${count.index}"
  }
}

### Route for NAT Gateway ###
resource "aws_route" "nat_route" {
  count = length(var.availability_zones)
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw_primary[count.index].id
}

### Example Network ACLs ###
resource "aws_network_acl" "acl" {
  count = 2
  vpc_id = aws_vpc.vpc_primary.id
  tags = {
    Name = "${element(["apps-acl", "private-acl"], count.index)}"
  }
}

resource "aws_network_acl_rule" "acl_rule" {
  count = 2
  network_acl_id = aws_network_acl.acl[count.index].id
  rule_number    = count.index == 0 ? 100 : 200
  protocol       = "tcp"
  rule_action    = "allow"
  egress         = count.index == 0 ? false : true
  cidr_block     = "0.0.0.0/0"
  from_port      = count.index == 0 ? 80 : 22
  to_port        = count.index == 0 ? 80 : 22
}

### Example Security Groups ###
# resource "aws_security_group" "sg" {
#   count = 2
#   vpc_id = aws_vpc.vpc_primary.id
#   tags = {
#     Name = element(["web-sg", "db-sg"], count.index)
#   }
# }

# resource "aws_security_group_rule" "sg_rule" {
#   count = 2
#   type        = count.index == 0 ? "ingress" : "egress"
#   from_port   = count.index == 0 ? 80 : 3306
#   to_port     = count.index == 0 ? 80 : 3306
#   protocol    = "tcp"
#   security_group_id = aws_security_group.sg[count.index].id
#   cidr_blocks = count.index == 0 ? ["0.0.0.0/0"] : ["10.0.0.0/16"]
# }

# ### Custom Route for Peering ###
# resource "aws_route" "vpc_peering" {
#   route_table_id         = aws_route_table.external.id
#   destination_cidr_block = "10.1.0.0/16"
#   vpc_peering_connection_id = "vpc-secondary" # replace with actual peering connection ID
# }
