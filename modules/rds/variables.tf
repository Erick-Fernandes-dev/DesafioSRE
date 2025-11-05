variable "desafio_sre" { type = string }
variable "db_password" {
  description = "Senha para o banco de dados RDS"
  type        = string
  sensitive   = true 
}
variable "private_subnets" { type = list(string) }
variable "sg_rds" { type = string }