output "alb_target_group_arn"{
    value = aws_lb_target_group.alb_target_group.arn
}

output "application_load_balancer_dns_name"{
    value = aws_lb.application_load_balancer.dns_name
}

output "application_load_balancer_zone_id"{
    value = aws_lb.application_load_balancer.zone_id
}

output "reverse_proxy_tg_arn" {
  value = aws_lb_target_group.reverse_proxy_tg.arn
          //aws_lb_target_group" "alb_target_group
}

output "private_ec2_tg_arn" {
  value = aws_lb_target_group.private_ec2_tg.arn
}