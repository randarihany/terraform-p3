/*# create application load balancer
resource "aws_lb" "application_load_balancer" {
 // name               = "alb"
  //internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = [var.public_subnet_az1_id,var.public_subnet_az2_id,]
  enable_deletion_protection = false
  
  name               = var.name
  internal           = var.internal

  tags   = {
    Name = "alb"
  }
}

# create target group
resource "aws_lb_target_group" "alb_target_group" {
  name        = "tg"
  target_type = "ip"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
    interval            = 300
    path                = "/"
    timeout             = 60
    matcher             = 200
    healthy_threshold   = 5
    unhealthy_threshold = 5
  }

  lifecycle {
    create_before_destroy = true
  }
}

# create a listener on port 80 with redirect action
resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# create a listener on port 443 with forward action
resource "aws_lb_listener" "alb_https_listener" {
  load_balancer_arn  = aws_lb.application_load_balancer.arn
  port               = 443
  protocol           = "HTTPS"
  //ssl_policy         = "ELBSecurityPolicy-2016-08"
  //certificate_arn    = 

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}*/

# Public Application Load Balancer
resource "aws_lb" "public_alb" {
  name               = var.public_alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public_alb_sg.id]
  subnets            = [var.public_subnet_az1_id, var.public_subnet_az2_id]
  enable_deletion_protection = false

  tags = {
    Name = var.public_alb_name
  }
}

# Private Application Load Balancer
resource "aws_lb" "private_alb" {
  name               = var.private_alb_name
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.private_alb_sg.id]
  subnets            = [var.private_subnet_az1_id, var.private_subnet_az2_id]
  enable_deletion_protection = false

  tags = {
    Name = var.private_alb_name
  }
}

# Target group for the public ALB (reverse proxy EC2 instances)
resource "aws_lb_target_group" "reverse_proxy_tg" {
  name        = "reverse-proxy-tg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

# Target group for the private ALB (private EC2 instances)
resource "aws_lb_target_group" "private_ec2_tg" {
  name        = "private-ec2-tg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

# Listener for the public ALB (HTTP to HTTPS redirect)
resource "aws_lb_listener" "public_alb_http_listener" {
  load_balancer_arn = aws_lb.public_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# Listener for the public ALB (HTTPS forward to reverse proxy)
resource "aws_lb_listener" "public_alb_https_listener" {
  load_balancer_arn = aws_lb.public_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.reverse_proxy_tg.arn
  }
}

# Listener for the private ALB (HTTP forward to private EC2)
resource "aws_lb_listener" "private_alb_http_listener" {
  load_balancer_arn = aws_lb.private_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.private_ec2_tg.arn
  }
}