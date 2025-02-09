
output "region" {
  value = var.region
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_azl_id"{
 value = aws_subnet.public_subnet_az1.id
}

output "public_subnet_az2_id" {
  value = aws_subnet.public_subnet_az2.id
}

output "private_app_subnet_azl_id" {
  value = aws_subnet.private_subnet_az1.id
}

output "private_app_subnet_az2_id" {
  value = aws_subnet.private_subnet_az2.id
}

output "internet_gateway" {
  value = aws_internet_gateway.internet_gateway
}

# Output availability zones if needed
output "availability_zones" {
  value = ["us-east-1a", "us-east-1b"]  # or use `data.aws_availability_zones.available.names`
}


