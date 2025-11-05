variable "desafio_sre" { type = string }
variable "vpc_id" { type = string }
variable "private_subnets" { type = list(string) }
variable "sg_efs" { type = string }