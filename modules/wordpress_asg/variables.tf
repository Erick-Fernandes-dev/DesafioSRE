variable "desafio_sre" { type = string }
variable "ec2_key_name" { type = string }
variable "private_subnets" { type = list(string) }
variable "sg_wordpress_ec2" { type = string }
variable "target_group_arn" { type = string }