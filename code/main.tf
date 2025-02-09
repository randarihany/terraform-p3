# Configure AWS provider
provider "aws" {
  region = "us-east-1"
}

# Create VPC
module "vpc" {
  source = "../modules/vpc"

  region                  = "us-east-1"
  vpc_cidr                = "10.0.0.0/16"
  public_subnet_az1_cidr  = "10.0.0.0/24"
  public_subnet_az2_cidr  = "10.0.1.0/24"
  private_subnet_az1_cidr = "10.0.2.0/24"
  private_subnet_az2_cidr = "10.0.3.0/24"
  availability_zones      = ["us-east-1a", "us-east-1b"]
}

# Create security groups
module "security_groups" {
  source = "../modules/security-groups"
  vpc_id = module.vpc.vpc_id
}

# Create public ALB
module "public_alb" {
  source = "../modules/alb"

  alb_security_group_id = module.security_groups.public_alb_security_group_id
  public_subnet_az1_id  = module.vpc.availability_zones[0]
  public_subnet_az2_id  = module.vpc.availability_zones[1]
  vpc_id                = module.vpc.vpc_id
  name                  = "public-alb"
  internal              = false
}

# Create private ALB
module "private_alb" {
  source = "../modules/alb"

  alb_security_group_id = module.security_groups.private_alb_security_group_id
  public_subnet_az1_id  = module.vpc.availability_zones[0]
  public_subnet_az2_id  = module.vpc.availability_zones[1]
  vpc_id                = module.vpc.vpc_id
  name                  = "private-alb"
  internal              = true
}

# Create reverse proxy EC2 instances in public subnets
module "reverse_proxy_ec2_az1" {
  source = "../modules/ec2"

  launch_template_name       = "reverse-proxy-az1"
  instance_type              = "t2.micro"
  associate_public_ip_address = true
  security_groups            = [module.security_groups.reverse_proxy_security_group_id]
  user_data_script           = "user_data_reverse_proxy.sh"
  instance_name              = "reverse-proxy-az1"
  subnet_id                  = module.vpc.public_subnet_az1_id
                                          
}

module "reverse_proxy_ec2_az2" {
  source = "../modules/ec2"

  launch_template_name       = "reverse-proxy-az2"
  instance_type              = "t2.micro"
  associate_public_ip_address = true
  security_groups            = [module.security_groups.reverse_proxy_security_group_id]
  user_data_script           = "user_data_reverse_proxy.sh"
  instance_name              = "reverse-proxy-az2"
  subnet_id                  = module.vpc.public_subnet_az2_id
}

# Create Apache EC2 instances in private subnets
module "apache_ec2_az1" {
  source = "../modules/ec2"

  launch_template_name       = "apache-az1"
  instance_type              = "t2.micro"
  associate_public_ip_address = false
  security_groups            = [module.security_groups.private_ec2_security_group_id]
  user_data_script           = "user_data_apache.sh"
  instance_name              = "apache-az1"
  subnet_id                  = module.vpc.private_subnet_az1_id
}

module "apache_ec2_az2" {
  source = "../modules/ec2"

  launch_template_name       = "apache-az2"
  instance_type              = "t2.micro"
  associate_public_ip_address = false
  security_groups            = [module.security_groups.private_ec2_security_group_id]
  user_data_script           = "user_data_apache.sh"
  instance_name              = "apache-az2"
  subnet_id                  = module.vpc.private_subnet_az2_id
}

# Attach reverse proxy EC2 instances to the public ALB target group
resource "aws_lb_target_group_attachment" "reverse_proxy_az1" {
  target_group_arn = module.public_alb.reverse_proxy_tg_arn
  target_id        = module.reverse_proxy_ec2_az1.instance_id
  port             = 80
}

resource "aws_lb_target_group_attachment" "reverse_proxy_az2" {
  target_group_arn = module.public_alb.reverse_proxy_tg_arn
  target_id        = module.reverse_proxy_ec2_az2.instance_id
  port             = 80
}

# Attach Apache EC2 instances to the private ALB target group
resource "aws_lb_target_group_attachment" "apache_az1" {
  target_group_arn = module.private_alb.private_ec2_tg_arn
  target_id        = module.apache_ec2_az1.instance_id
  port             = 80
}

resource "aws_lb_target_group_attachment" "apache_az2" {
  target_group_arn = module.private_alb.private_ec2_tg_arn
  target_id        = module.apache_ec2_az2.instance_id
  port             = 80
}




/*#configure aws provider
provider "aws" {
  region = "us-east-1"
}

#create vpc
module "vpc" {

  source = "../modules/vpc"  
  region = "us-east-1"
  vpc_cidr = "10.0.0.0/16"
  public_subnet_az1_cidr = "10.0.0.0/24"
  public_subnet_az2_cidr = "10.0.1.0/24"
  private_subnet_az1_cidr = "10.0.2.0/24"
  private_subnet_az2_cidr = "10.0.3.0/24"
    
# Define the availability zones explicitly
availability_zones = ["us-east-1a", "us-east-1b"]
}


module "security_group"{
  source = "../modules/security-groups"
  vpc_id = module.vpc.vpc_id
}


# Create public ALB
module "public_alb" {
  source = "../modules/alb"

  alb_security_group_id = module.security_group.alb_security_group_id
  public_subnet_az1_id  = module.vpc.availability_zones[0]
  public_subnet_az2_id  = module.vpc.availability_zones[1]
  vpc_id                = module.vpc.vpc_id
  name                  = "public-alb"  
  internal              = false
}

# Create private ALB
module "private_alb" {
  source = "../modules/alb"

  alb_security_group_id = module.security_group.alb_security_group_id
  public_subnet_az1_id  = module.vpc.availability_zones[0]
  public_subnet_az2_id  = module.vpc.availability_zones[1]
  vpc_id                = module.vpc.vpc_id
  internal              = true  # Make the ALB internal (private)
  name                  = "private-alb"  #
}

# Create reverse proxy EC2 instances in public subnets
module "reverse_proxy_ec2_az1" {
  source = "../modules/ec2"

  launch_template_name       = "reverse-proxy-az1"
  instance_type              = "t2.micro"
  associate_public_ip_address = true
  security_groups            = [module.security_group.ec2_security_group_id]
  user_data_script           = "user_data_reverse_proxy.sh"
  instance_name              = "reverse-proxy-az1"
  subnet_id                  = module.vpc.public_subnet_azl_id
}

module "reverse_proxy_ec2_az2" {
  source = "../modules/ec2"

  launch_template_name       = "reverse-proxy-az2"
  instance_type              = "t2.micro"
  associate_public_ip_address = true
  security_groups            = [module.security_group.ec2_security_group_id]
  user_data_script           = "user_data_reverse_proxy.sh"
  instance_name              = "reverse-proxy-az2"
  subnet_id                  = module.vpc.public_subnet_az2_id
}

# Create Apache EC2 instances in private subnets
module "apache_ec2_az1" {
  source = "../modules/ec2"

  launch_template_name       = "apache-az1"
  instance_type              = "t2.micro"
  associate_public_ip_address = false
  security_groups            = [module.security_group.ec2_security_group_id]
  user_data_script           = "user_data_apache.sh"
  instance_name              = "apache-az1"
  subnet_id                  = module.vpc.private_app_subnet_azl_id
}

module "apache_ec2_az2" {
  source = "../modules/ec2"

  launch_template_name       = "apache-az2"
  instance_type              = "t2.micro"
  associate_public_ip_address = false
  security_groups            = [module.security_group.ec2_security_group_id]
  user_data_script           = "user_data_apache.sh"
  instance_name              = "apache-az2"
  subnet_id                  = module.vpc.private_app_subnet_az2_id
}


# Attach reverse proxy EC2 instances to the public ALB target group
resource "aws_lb_target_group_attachment" "reverse_proxy_az1" {
  target_group_arn = module.public_alb.alb_target_group_arn
  target_id        = module.reverse_proxy_ec2.instance_ids[0]
  port             = 80
}

resource "aws_lb_target_group_attachment" "reverse_proxy_az2" {
  target_group_arn = module.public_alb.alb_target_group_arn
  target_id        = module.reverse_proxy_ec2.instance_ids[1]
  port             = 80
}

# Attach Apache EC2 instances to the private ALB target group
resource "aws_lb_target_group_attachment" "apache_az1" {
  target_group_arn = module.private_alb.alb_target_group_arn
  target_id        = module.apache_ec2.instance_ids[0]
  port             = 80
}

resource "aws_lb_target_group_attachment" "apache_az2" {
  target_group_arn = module.private_alb.alb_target_group_arn
  target_id        = module.apache_ec2.instance_ids[1]
  port             = 80
}  */