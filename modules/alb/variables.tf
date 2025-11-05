variable "desafio_sre" { type = string }
variable "vpc_id" { type = string }
variable "public_subnets" { type = list(string) }
variable "sg_alb" { type = string }