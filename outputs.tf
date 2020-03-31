
output "vpc_id" {
  value = aws_vpc.the_vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet.id
}

output "public_ec2_id" {
  value = aws_instance.web.id
}

output "private_ec2_id" {
  value = aws_instance.db.id
}
