

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb"></a> [alb](#module\_alb) | ./modules/alb | n/a |
| <a name="module_efs"></a> [efs](#module\_efs) | ./modules/efs | n/a |
| <a name="module_elasticache"></a> [elasticache](#module\_elasticache) | ./modules/elasticache | n/a |
| <a name="module_pritunl"></a> [pritunl](#module\_pritunl) | ./modules/pritunl | n/a |
| <a name="module_private_docker"></a> [private\_docker](#module\_private\_docker) | ./modules/private_docker | n/a |
| <a name="module_rds"></a> [rds](#module\_rds) | ./modules/rds | n/a |
| <a name="module_security"></a> [security](#module\_security) | ./modules/security | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ./modules/vpc | n/a |
| <a name="module_wordpress_asg"></a> [wordpress\_asg](#module\_wordpress\_asg) | ./modules/wordpress_asg | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Zonas de disponibilidade para implantar os recursos. | `list(string)` | <pre>[<br/>  "us-west-2a",<br/>  "us-west-2b"<br/>]</pre> | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | Região da AWS para implantar o recursos. | `string` | `"us-west-2"` | no |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Senha para o banco de dados RDS. | `string` | `"Tbwa!.0002"` | no |
| <a name="input_desafio_sre"></a> [desafio\_sre](#input\_desafio\_sre) | Desafio SRE - Elven Works | `string` | `"wordpres-ha"` | no |
| <a name="input_ec2_key_name"></a> [ec2\_key\_name](#input\_ec2\_key\_name) | Nome da chave SSH para acessar as instâncias EC2. | `string` | `"estudos-erick"` | no |
| <a name="input_private_subnets_cidr"></a> [private\_subnets\_cidr](#input\_private\_subnets\_cidr) | Bloco CIDR para a sub-rede privada. | `list(string)` | <pre>[<br/>  "10.11.3.0/24",<br/>  "10.11.4.0/24"<br/>]</pre> | no |
| <a name="input_profile"></a> [profile](#input\_profile) | Perfil da AWS CLI para usar. | `string` | `"elven-testes"` | no |
| <a name="input_public_subnets_cidr"></a> [public\_subnets\_cidr](#input\_public\_subnets\_cidr) | Bloco CIDR para a sub-rede pública. | `list(string)` | <pre>[<br/>  "10.11.1.0/24",<br/>  "10.11.2.0/24"<br/>]</pre> | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | Bloco CIDR para a VPC. | `string` | `"10.11.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_dns_name"></a> [alb\_dns\_name](#output\_alb\_dns\_name) | DNS do Application Load Balancer para acessar o WordPress. |
| <a name="output_efs_id"></a> [efs\_id](#output\_efs\_id) | ID do sistema de arquivos EFS. |
| <a name="output_elasticache_endpoint"></a> [elasticache\_endpoint](#output\_elasticache\_endpoint) | Endpoint de configuracao do ElastiCache Memcached. |
| <a name="output_pritunl_public_ip"></a> [pritunl\_public\_ip](#output\_pritunl\_public\_ip) | IP Publico do servidor Pritunl para acesso a UI Web. |
| <a name="output_private_docker_instance_ip"></a> [private\_docker\_instance\_ip](#output\_private\_docker\_instance\_ip) | IP Privado da instancia com a aplicacao Hello World. |
| <a name="output_rds_db_name"></a> [rds\_db\_name](#output\_rds\_db\_name) | Nome do banco de dados RDS. |
| <a name="output_rds_db_user"></a> [rds\_db\_user](#output\_rds\_db\_user) | Usuario do banco de dados RDS. |
| <a name="output_rds_endpoint"></a> [rds\_endpoint](#output\_rds\_endpoint) | Endpoint do banco de dados RDS. |
| <a name="output_wordpress_instance_ips"></a> [wordpress\_instance\_ips](#output\_wordpress\_instance\_ips) | IPs privados das instancias do WordPress (para o Ansible). |
<!-- END_TF_DOCS -->