output "sg_alb_id" { value = aws_security_group.alb.id }
output "sg_wordpress_id" { value = aws_security_group.wordpress.id }
output "sg_rds_id" { value = aws_security_group.rds.id }
output "sg_elasticache_id" { value = aws_security_group.elasticache.id }
output "sg_efs_id" { value = aws_security_group.efs.id }
output "sg_pritunl_id" { value = aws_security_group.pritunl.id }
output "sg_private_docker_id" { value = aws_security_group.private_docker.id }