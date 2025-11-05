variable "vpc_id" { type = string }

variable "vpc_cidr" {
  description = "Bloco CIDR da VPC para as regras do SG"
  type        = string
}