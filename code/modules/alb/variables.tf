
variable "alb_security_group_id" {
   type = string
}

variable "public_subnet_az1_id" {
   type = string
}
variable "public_subnet_az2_id" {
   type = string
}

variable "vpc_id" {
   type = string
}

variable "name" {
  type    = string
 
}

variable "internal" {
  type    = bool
}