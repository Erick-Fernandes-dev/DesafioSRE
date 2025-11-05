# 1. Security Group para o Application Load Balancer (ALB)
resource "aws_security_group" "alb" {
  name        = "alb-sg"
  description = "Permite trafego HTTP/HTTPS para o ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 2. Security Group para as instâncias WordPress
resource "aws_security_group" "wordpress" {
  name        = "wordpress-ec2-sg"
  description = "Permite trafego do ALB e acesso SSH do Bastion" # Descrição atualizada
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  # --- REGRA DE SSH CORRIGIDA ---
  # Permite SSH (porta 22) vindo de qualquer instância
  # que esteja no Security Group "pritunl-sg".
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.pritunl.id]
    description     = "Permite SSH do Bastion (Pritunl)"
  }
  # --- FIM DA CORREÇÃO ---

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. Security Group para o RDS
resource "aws_security_group" "rds" {
  name        = "rds-sg"
  description = "Permite trafego do WordPress para o MySQL"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.wordpress.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 4. Security Group para o ElastiCache
resource "aws_security_group" "elasticache" {
  name        = "elasticache-sg"
  description = "Permite trafego do WordPress para o Memcached"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 11211
    to_port         = 11211
    protocol        = "tcp"
    security_groups = [aws_security_group.wordpress.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 5. Security Group para o EFS
resource "aws_security_group" "efs" {
  name        = "efs-sg"
  description = "Permite trafego NFS do WordPress"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.wordpress.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 6. Security Group para o Pritunl
resource "aws_security_group" "pritunl" {
  name        = "pritunl-sg"
  description = "Permite acesso web e VPN ao Pritunl"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 1194 # Porta padrão OpenVPN
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 7. Security Group para a Instância Docker Privada
resource "aws_security_group" "private_docker" {
  name        = "private-docker-sg"
  description = "Permite acesso do Pritunl (VPN)"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr] # Permite SSH de qualquer lugar da VPC (idealmente, restrinja ao IP da VPN)
  }
  ingress {
    from_port   = 8080 # Porta da aplicação Nginx Hello
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr, "192.168.100.0/24"] # Permite acesso da rede VPN Pritunl
    description = "Permitir App (8080) da VPC e da VPN"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}