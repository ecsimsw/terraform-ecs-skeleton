output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = [
    aws_subnet.public_subnet_2a.id,
    aws_subnet.public_subnet_2c.id,
  ]
}

output "private_subnet_ids" {
  value = [
    aws_subnet.private_subnet_2a.id,
    aws_subnet.private_subnet_2c.id
  ]
}