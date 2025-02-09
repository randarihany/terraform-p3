output "public_alb_security_group_id"{
    value = aws_security_group.public_alb_sg.id
}

output "reverse_proxy_security_group_id"{
    value = aws_security_group.reverse_proxy_sg.id
}

output "private_alb_security_group_id"{
    value = aws_security_group.private_alb_sg.id
}

output "private_ec2_security_group_id"{
    value = aws_security_group.private_ec2_sg.id
}






