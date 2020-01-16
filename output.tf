# Uncomment this when you have the solution

output "web_ip" {
	value = aws_instance.web.public_ip
}

output "web_dns" {
	value = aws_instance.web.public_dns
}

output "public_key" {
	value = "var.public_key"
}

output "ssh_command" {
	value = "ssh -i ./keys/aws_terraform ec2-user@${aws_instance.web.public_dns}"
}

# Only uncomment if you have a hosted zone in Route53
# output "web_dns" {
#   value = aws_route53_record.dns_web.name
# }
