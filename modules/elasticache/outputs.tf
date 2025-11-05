output "elasticache_endpoint" {
  value = aws_elasticache_cluster.main.configuration_endpoint
}