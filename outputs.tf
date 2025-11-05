output "alb_dns_name" {
  description = "DNS do Application Load Balancer para acessar o WordPress."
  value       = module.alb.alb_dns_name
}

output "pritunl_public_ip" {
  description = "IP Publico do servidor Pritunl para acesso a UI Web."
  value       = module.pritunl.pritunl_public_ip
}

output "private_docker_instance_ip" {
  description = "IP Privado da instancia com a aplicacao Hello World."
  value       = module.private_docker.private_ip
}

output "rds_endpoint" {
  description = "Endpoint do banco de dados RDS."
  value       = module.rds.db_endpoint
}

output "rds_db_name" {
  description = "Nome do banco de dados RDS."
  value       = module.rds.db_name
}

output "rds_db_user" {
  description = "Usuario do banco de dados RDS."
  value       = module.rds.db_user
}

output "elasticache_endpoint" {
  description = "Endpoint de configuracao do ElastiCache Memcached."
  value       = module.elasticache.elasticache_endpoint
}

output "efs_id" {
  description = "ID do sistema de arquivos EFS."
  value       = module.efs.efs_id
}

output "wordpress_instance_ips" {
  description = "IPs privados das instancias do WordPress (para o Ansible)."
  value       = module.wordpress_asg.private_ips
}