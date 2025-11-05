data "aws_ssm_parameter" "ubuntu_ami" {
  name = "/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id"
}

resource "aws_instance" "pritunl" {
  ami                    = data.aws_ssm_parameter.ubuntu_ami.value
  instance_type          = "t3.large"
  key_name               = var.ec2_key_name
  subnet_id              = var.public_subnet
  vpc_security_group_ids = [var.sg_pritunl]

  # NENHUM user_data. O Ansible vai instalar.

  tags = {
    Name = "${var.desafio_sre}-pritunl-server"
  }
}

resource "aws_eip" "pritunl" {
  instance = aws_instance.pritunl.id
  domain   = "vpc"
}

resource "aws_cloudwatch_metric_alarm" "pritunl_cpu" {
  alarm_name          = "${var.desafio_sre}-pritunl-cpu-utilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description = "This metric monitors EC2 CPU utilization for Pritunl instance"
  
  dimensions = {
    InstanceId = aws_instance.pritunl.id
  }
}