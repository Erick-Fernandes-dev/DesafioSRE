data "aws_ssm_parameter" "ubuntu_ami" {
  name = "/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id"
}

resource "aws_launch_template" "wordpress" {
  name_prefix            = "${var.desafio_sre}-wp-"
  image_id               = data.aws_ssm_parameter.ubuntu_ami.value
  instance_type          = "t3.large"
  key_name               = var.ec2_key_name
  vpc_security_group_ids = [var.sg_wordpress_ec2]

  # NÃO há 'user_data' aqui! O Ansible fará a configuração.

  tags = {
    Name = "${var.desafio_sre}-wordpress"
  }
}

resource "aws_autoscaling_group" "wordpress" {
  name                = "${var.desafio_sre}-wp-asg"
  vpc_zone_identifier = var.private_subnets
  desired_capacity    = 2
  min_size            = 2
  max_size            = 6

  target_group_arns = [var.target_group_arn]
  health_check_type = "ELB"

  health_check_grace_period = 900 # (15 minutos)

  launch_template {
    id      = aws_launch_template.wordpress.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.desafio_sre}-wordpress"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "cpu_scaling" {
  name                   = "${var.desafio_sre}-cpu-scaling-policy"
  autoscaling_group_name = aws_autoscaling_group.wordpress.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 70.0 # Escalar quando a CPU média atingir 70%
  }
}

# Data source para obter os IPs das instâncias criadas pelo ASG
data "aws_instances" "wordpress" {
  instance_tags = {
    Name = "${var.desafio_sre}-wordpress"
  }
  instance_state_names = ["running"]
  depends_on           = [aws_autoscaling_group.wordpress]
}