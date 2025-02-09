variable "launch_template_name" {
  description = "Name of the launch template"
  type        = string
  default     = "web-server"
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "associate_public_ip_address" {
  description = "Should the EC2 instance be associated with a public IP address"
  type        = bool
  default     = false
}

variable "security_groups" {
  description = "List of security group IDs to assign to the instance"
  type        = list(string)
}

variable "user_data_script" {
  description = "Path to the user data script (will be base64 encoded)"
  type        = string
  default     = "userdata.sh"
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "ec2-web-server"
}

variable "subnet_id" {
  type = string
}