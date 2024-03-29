
#create the vpc
resource "aws_vpc" "the_vpc" {
  cidr_block = var.vpc_cidr
}

#create the public subnet, cidr set to 10.0.1.0/24
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.the_vpc.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = "eu-west-2c"

  tags = {
    name = "Web public subnet"
  }
}

#create the private subnet, cidr set to 10.0.2.0/24
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.the_vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = "eu-west-2c"

  tags = {
    Name = "Database private subnet"
  }
}




#create the internet gateway and specify the vpc it is required for
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.the_vpc.id

  tags = {
    Name = "VPC IGW"
  }
}




#create the route table for pub-sub and specify which vpc it should be created in
resource "aws_route_table" "route-table" {
  vpc_id = aws_vpc.the_vpc.id

  #specify which cidr the route can have access to and through which gateway 
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public subnet rt"
  }
}
#attach the route to the public subnet. Difference between private and public s#subnets is that private doesnt have a route table
resource "aws_route_table_association" "rt-assign" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.route-table.id
}

#create the route table for priv-sub and specify which vpc it should be created in
resource "aws_route_table" "route-table-priv" {
  vpc_id = aws_vpc.the_vpc.id

  #specify which cidr the route can have access to and through which gateway 
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }

  tags = {
    Name = "Private subnet rt"
  }
}
#attach the route to the private subnet. Difference between private and public subnets is that the route table points to the nat gateway
resource "aws_route_table_association" "rt-priv-assign" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.route-table-priv.id
}
resource "aws_security_group" "sgweb" {
  name = "sg_test_web"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  #Ingress can be changed  to let in just your IP address. 
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = aws_vpc.the_vpc.id

  tags = {
    Name = "Web Server SG"
  }
}

resource "aws_security_group" "sgdb" {
  name = "sg_ttest_web"

  #only allows ssh of internal IP address.
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.public_subnet_cidr]
  }
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  vpc_id = aws_vpc.the_vpc.id

  tags = {
    Name = "Db SG"
  }
}

resource "aws_eip" "eip_for_nat" {
  vpc                       = true
  associate_with_private_ip = "10.0.1.0"
  depends_on                = ["aws_internet_gateway.igw"]
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.eip_for_nat.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "gw NAT in pub sub"
  }

  depends_on = ["aws_internet_gateway.igw"]
}







