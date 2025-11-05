
output "private_ip" {
  description = "The private IP address of the Docker EC2 instance"
  value       = aws_instance.private_docker.private_ip
}
