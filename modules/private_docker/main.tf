data "aws_ssm_parameter" "ubuntu_ami" {
  name = "/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id"
}

resource "aws_instance" "private_docker" {
  ami                    = data.aws_ssm_parameter.ubuntu_ami.value
  instance_type          = "t3.micro"
  key_name               = var.ec2_key_name
  subnet_id              = var.private_subnet
  vpc_security_group_ids = [var.sg_private_docker]

  # NENHUM user_data. O Ansible vai instalar.

  tags = {
    Name = "${var.desafio_sre}-private-docker"
  }
}

resource "aws_cloudwatch_metric_alarm" "private_docker_cpu" {
  alarm_name          = "${var.desafio_sre}-private-docker-cpu-utilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "50"
  alarm_description   = "This metric monitors EC2 CPU utilization for Private Docker instance"

  dimensions = {
    InstanceId = aws_instance.private_docker.id
  }
}