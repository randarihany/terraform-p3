# Data source to get the AMI dynamically
data "aws_ami" "selected_ami" {
  most_recent = true
  owners      = ["amazon"]  # This can be customized based on your requirements

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]  # This pattern is for Amazon Linux 2 AMIs
  }
}

# EC2 Launch Template
resource "aws_launch_template" "ec2" {
  name          = var.launch_template_name
  image_id      = data.aws_ami.selected_ami.id  # Dynamically fetch the AMI ID
  instance_type = var.instance_type
  
  
  network_interfaces {
    associate_public_ip_address = var.associate_public_ip_address
    security_groups            = var.security_groups
    subnet_id     = var.subnet_id
  }

  user_data = filebase64(var.user_data_script)  # User data (base64 encoded)

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = var.instance_name
    }
  }
}
