resource "aws_elasticache_subnet_group" "main" {
  name       = "${var.desafio_sre}-cache-subnet-group"
  subnet_ids = var.private_subnets
}

resource "aws_elasticache_cluster" "main" {
  cluster_id           = "${var.desafio_sre}-memcached"
  engine               = "memcached"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 2
  parameter_group_name = "default.memcached1.6"
  port                 = 11211
  subnet_group_name    = aws_elasticache_subnet_group.main.name
  security_group_ids   = [var.sg_elasticache]
}

resource "aws_cloudwatch_metric_alarm" "cache_cpu" {
  alarm_name          = "${var.desafio_sre}-memcached-cpu-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "Alarme de CPU alta no Memcached"
  dimensions = {
    CacheClusterId = aws_elasticache_cluster.main.cluster_id
  }
}