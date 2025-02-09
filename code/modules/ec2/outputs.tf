output "launch_template_id" {
  description = "ID of the created EC2 launch template"
  value       = aws_launch_template.ec2.id
}

output "launch_template_name" {
  description = "Name of the created EC2 launch template"
  value       = aws_launch_template.ec2.name
}
