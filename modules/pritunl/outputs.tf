output "pritunl_public_ip" {
  value = aws_eip.pritunl.public_ip
}