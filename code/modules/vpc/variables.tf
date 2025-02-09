variable "region" {}
variable "vpc_cidr" {}
variable "public_subnet_az1_cidr" {
 description = "CIDR block for public subnet in AZ1"
  type        = string
}
variable "public_subnet_az2_cidr" {
  description = "CIDR block for public subnet in AZ2"
  type        = string
}
variable "private_subnet_az1_cidr"{
  description = "CIDR block for private subnet in AZ1"
  type        = string
}
variable "private_subnet_az2_cidr" {
  description = "CIDR block for private subnet in AZ2"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}