variable "aws_region" {
  description = "Região da AWS para implantar o recursos."
  type        = string
  default     = "us-west-2"
}

variable "desafio_sre" {
  description = "Desafio SRE - Elven Works"
  type        = string
  default     = "wordpres-ha"
}

variable "vpc_cidr" {
  description = "Bloco CIDR para a VPC."
  type        = string
  default     = "10.11.0.0/16"
}

variable "public_subnets_cidr" {
  description = "Bloco CIDR para a sub-rede pública."
  type        = list(string)
  default     = ["10.11.1.0/24", "10.11.2.0/24"]
}

variable "private_subnets_cidr" {
  description = "Bloco CIDR para a sub-rede privada."
  type        = list(string)
  default     = ["10.11.3.0/24", "10.11.4.0/24"]
}

variable "availability_zones" {
  description = "Zonas de disponibilidade para implantar os recursos."
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b"]
}

variable "ec2_key_name" {
  description = "Nome da chave SSH para acessar as instâncias EC2."
  type        = string
  // IMPORTANTE: Substitua pelo nome do seu par de chaves!
  default = "estudos-erick"
}

variable "db_password" {
  description = "Senha para o banco de dados RDS."
  type        = string
  sensitive   = true
  // IMPORTANTE: Substitua por uma senha forte ou use o Secrets Manager.
  default = "Tbwa!.0002"
}

variable "profile" {
  description = "Perfil da AWS CLI para usar."
  type        = string
  default     = "elven-testes"

}