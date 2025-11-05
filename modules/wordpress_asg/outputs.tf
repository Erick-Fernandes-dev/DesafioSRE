output "private_ips" {
  value = data.aws_instances.wordpress.private_ips
}