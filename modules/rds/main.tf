resource "aws_db_subnet_group" "main" {
  name       = "${var.desafio_sre}-rds-subnet-group"
  subnet_ids = var.private_subnets
  tags = {
    Name = "${var.desafio_sre}-rds-subnet-group"
  }
}

resource "aws_db_instance" "main" {
  identifier             = "${var.desafio_sre}-rds"
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  db_name                = "${replace(var.desafio_sre, "-", "")}db"
  username               = "admin"
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.sg_rds]
  skip_final_snapshot    = true
  multi_az               = true # Requisito de Alta Disponibilidade
}

resource "aws_cloudwatch_metric_alarm" "rds_cpu" {
  alarm_name          = "${var.desafio_sre}-rds-cpu-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "Alarme de CPU alta no RDS"
  dimensions = {
    DBInstanceIdentifier = aws_db_instance.main.identifier
  }
}