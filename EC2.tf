
resource "aws_instance" "web" {
  ami                         = var.ami
  instance_type               = "t2.micro"
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.sgweb.id]
  associate_public_ip_address = true

  tags = {
    Name = "Public instance for wbserv"
  }
}

resource "aws_instance" "db" {
  ami                    = var.ami
  instance_type          = "t2.micro"
  key_name               = var.key_name
  subnet_id              = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.sgdb.id]

  tags = {
    Name = "private instance for db"
  }
}

