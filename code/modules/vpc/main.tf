#Create vpc
resource "aws_vpc" "vpc"{
    cidr_block = var.vpc_cidr
    instance_tenancy = "default"
    enable_dns_hostnames = true
    
    tags = {
        Name = "vpc"
    }
}

#create internet gateway and attac it to vpc
resource "aws_internet_gateway" "internet_gateway"{
    vpc_id = aws_vpc.vpc.id
    
    tags = {
        Name = "igw"
    }
}

#use data source to get all avaliablity zones in region
#data "aws_availability_zones" "available_zones" {}
 
#create public subnet az1
resource "aws_subnet" "public_subnet_az1" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.public_subnet_az1_cidr
    availability_zone = var.availability_zones[0]
    map_public_ip_on_launch = true
    
    tags = {
        Name = "Public Subnet AZ1"
    }
 }
 
 #create public subnet az2
resource "aws_subnet" "public_subnet_az2" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.public_subnet_az2_cidr
    availability_zone = var.availability_zones[1]
    map_public_ip_on_launch = true
    
    tags = {
        Name = "Public Subnet AZ2"
    }
 }
 
#create route table and public route
resource "aws_route_table" "pulic_route_table"{
    vpc_id = aws_vpc.vpc.id
    
    route {
        cidr_block = "0.0.0.0/16"
        gateway_id = aws_internet_gateway.internet_gateway.id
    }
    
    tags = {
        Name = "Public route table"
    }
    
}

#associate public subnet az1 to rt
resource "aws_route_table_association" "public_subnet_az1_rt_association"{
    subnet_id = aws_subnet.public_subnet_az1.id
    route_table_id = aws_route_table.pulic_route_table.id
}

#associate public subnet az2 to rt
resource "aws_route_table_association" "public_subnet_az2_rt_association"{
    subnet_id = aws_subnet.public_subnet_az2.id
    route_table_id = aws_route_table.pulic_route_table.id
}


#create private subnet az1
resource "aws_subnet" "private_subnet_az1" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.private_subnet_az1_cidr
    availability_zone = var.availability_zones[0]
    map_public_ip_on_launch = false
    
    tags = {
        Name = "Private Subnet AZ1"
    }
 }
 
#create private subnet az2
resource "aws_subnet" "private_subnet_az2" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.private_subnet_az2_cidr
    availability_zone = var.availability_zones[1]
    map_public_ip_on_launch = false
    
    tags = {
        Name = "Private Subnet AZ2"
    }
 }
 
 
 